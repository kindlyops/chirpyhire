class SearchesController < ApplicationController
  before_action :authenticate_account!

  def create
    current_account.searches.build do |search|
      search.questions << questions
      search.save!
    end
  end

  private

  def questions
    organization.questions.find(params[:search][:question_ids])
  end
end
