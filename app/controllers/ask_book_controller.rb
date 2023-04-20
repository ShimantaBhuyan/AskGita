class AskBookController < ApplicationController
    skip_before_action :verify_authenticity_token
    layout "ask_book"

    def ask
        question = params[:question]
        file_path = File.join(Rails.root, "questions.rb")
        # Run the Ruby script with the question as input
        response = `ruby #{file_path} #{question}`
        render json: response
    end
end