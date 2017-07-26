class Import::CsvController < ApplicationController
  layout 'wizard'

  def new
    @import = authorize new_import
  end

  def create
    @import = authorize build_import

    if @import.save
      redirect_to edit_import_csv_path(@import)
    else
      render :new
    end
  end

  def edit
    @import = authorize current_account.imports.find(params[:id])
  end

  private

  def build_import
    current_account.imports.build(permitted_attributes(Import))
  end

  def new_import
    current_account.imports.build
  end
end
