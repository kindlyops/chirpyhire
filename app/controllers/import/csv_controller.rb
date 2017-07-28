class Import::CsvController < ApplicationController
  layout 'wizard'

  def new
    @import = authorize new_import
  end

  def create
    @import = authorize build_import

    if Import::Create.call(@import)
      redirect_to edit_import_csv_mapping_path(@import, @import.first_mapping)
    else
      render :new
    end
  end

  private

  def build_import
    current_account.imports.build(permitted_attributes(Import))
  end

  def new_import
    current_account.imports.build
  end
end
