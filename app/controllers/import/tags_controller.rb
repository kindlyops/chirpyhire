class Import::TagsController < ApplicationController
  layout 'wizard'

  def new
    @import = fetch_import

    @tag = authorize(current_organization.tags.build(name: tag_name))
  end

  def create
    @import = fetch_import

    if tag
      redirect_to new_import_csv_summary_path(@import)
    else
      render :new
    end
  end

  private

  def tag
    @tag ||= begin
      current_organization.tags.find_or_create_by(permitted_attributes(Tag))
    end
  end

  def tag_name
    "CSV Import - #{Time.current.iso8601}"
  end

  def fetch_import
    authorize(current_account.imports.find(params[:csv_id]), :show?)
  end
end
