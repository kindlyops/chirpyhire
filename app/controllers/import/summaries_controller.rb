class Import::SummariesController < ApplicationController
  layout 'wizard'

  def new
    @import = fetch_import
  end

  def create
    # run import
    # redirect to import summary show
  end

  private

  def fetch_import
    authorize(current_account.imports.find(params[:csv_id]), :show?)
  end
end
