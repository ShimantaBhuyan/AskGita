require 'pdf-reader'

# Define the path to your PDF file
pdf_path = '/home/bhuyanshimanta/test-react-on-rails/BhagavatGita.pdf'

Dotenv.load()

openai = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])

text_array = []
embedding_array = []

# Initialize a PDF reader object
reader = PDF::Reader.new(pdf_path)

# Loop through each page in the PDF
reader.pages.each do |page|

  # Extract the text from the page
  text = page.text.gsub(/[^\w\s]/, '')

  # Split the text into chunks of maximum 2000 words each
  chunks = text.scan(/[\w'-]+(?:\W+[\w'-]+){0,1999}/)

  # Add the chunks to the text array
  text_array << chunks
end

text_array.each do |text|
    response = openai.embeddings(
        parameters: {
        model: "text-embedding-ada-002",
        input: text
        }
    )

    embedding = response['data'][0]['embedding']

    embedding_hash = {embedding: embedding, text: text}
    embedding_array << embedding_hash
end

CSV.open("embeddings.csv", "w") do |csv|
    csv << [:embedding, :text]
    embedding_array.each do |obj|
        csv << [obj[:embedding], obj[:text]]
    end
end
