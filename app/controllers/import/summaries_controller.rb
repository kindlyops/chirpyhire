class Import::SummariesController < ApplicationController
  layout 'wizard'

  def show
    @import = authorize current_account.imports.find(params[:csv_id])
  end
end
