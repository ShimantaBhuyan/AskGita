# AskKrishna

### Unlock mysteries of life from Krishna - Ask your questions and get them answered by Lord Krishna

#### Instructions to run locally
---

- ##### Add your `OPENAI_API_KEY` in a `.env` file in the root directory

- ##### Create embeddings from PDF
  - Run `generate-embeddings.rb` with the command `bundle exec rails r ./generate-embeddings.rb` in the root directory of the project
  - Update file path inside the file to indicate the correct file path of the PDF file, if needed.
  - This will generate `embeddings.csv` file.

- ##### Run the app locally
  - Run `./bin/dev` or `foreman start -f Procfile.dev` in the root directory (need to have `ruby`, `rails`, `foreman` installed)
