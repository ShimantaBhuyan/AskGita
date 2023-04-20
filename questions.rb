require 'dotenv'
require 'ruby/openai'
require 'csv'
require_relative 'cosine'

Dotenv.load()

openai = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

puts "Radhe Radhe! What can Krishna help you with today?"
question = gets

response = openai.embeddings(
  parameters: {
    model: "text-embedding-ada-002",
    input: question
  }
)

question_embedding = response['data'][0]['embedding']

similarity_array = []

CSV.foreach("embeddings.csv", headers: true) do |row|
  text_embedding = JSON.parse(row['embedding'])
    similarity_array << Cosine.new(question_embedding, text_embedding).calculate_similarity
end

index_of_max = similarity_array.index(similarity_array.max)
original_text = ""

CSV.foreach("embeddings.csv", headers: true).with_index do |row, rowno|
  if rowno == index_of_max
    original_text = row['text']
  end
end

prompt = 
"You are Krishna from Mahabharata, and you're here to selflessly help and answer any question or dilemma of anyone who comes to you. Analyze the person's question below and identify the base emotion and the root for this emotion, and then frame your answer by summarizing how the context below apply to their situation and be emphatetic in your answer. If the users question is not answered by the context you will respond with 'Radhe Radhe, this question eludes my conscience.' Do not respond with anything other than what's asked of you.
[Context]
#{original_text} 
"

userPrompt = "
[Question]
#{question}
"

response = openai.chat(
    parameters: {
        model: "gpt-3.5-turbo", 
        messages: [{ role: "system", content: prompt}, { role: "user", content: userPrompt}], 
        temperature: 0.5,
    })

puts "\nAI response:\n"
puts response.dig("choices", 0, "message", "content")