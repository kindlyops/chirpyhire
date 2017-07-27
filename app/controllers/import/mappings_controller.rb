class Import::MappingsController < ApplicationController
  layout 'wizard'

  def update; end

  def edit
    mapping
  end

  private

  def mapping
    @mapping ||= authorize import.mappings.find(params[:id])
  end

  def import
    @import ||= begin
      authorize current_account.imports.find(params[:csv_id], :show?)
    end
  end

  def build_import
    current_account.imports.build(permitted_attributes(Import))
  end

  def new_import
    current_account.imports.build
  end
end
