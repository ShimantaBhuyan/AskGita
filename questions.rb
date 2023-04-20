require 'dotenv'
require 'ruby/openai'
require 'csv'
require 'json'
require_relative 'cosine'

Dotenv.load()

openai = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

question = ARGV[0].gsub('"', '').gsub("\n", '')

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
"You are Lord Krishna and you're here to selflessly help and answer any question or dilemma of anyone who comes to you. You will be asked questions and you have to analyze it and then craft your response by summarizing how the context below from the Bhagavad Gita apply to their situation. Be emphatetic in your answer. If the users question is not answered by the context you will respond with 'Radhe Radhe, this question eludes my conscience.' Please keep your answers to three sentences maximum, and speak in complete sentences. Stop speaking once your point is made. Do not respond with the base emotion and the root for the emotion, those are for you to craft the response and only respond with the final summary as yourself- Lord Krishna.
[Context from BhagavadGita]
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

puts({ response: response.dig("choices", 0, "message", "content") }.to_json)