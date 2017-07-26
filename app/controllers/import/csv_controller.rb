class Import::CsvController < ApplicationController
  layout 'wizard'

  def new
    @import = authorize new_import
  end

  private

  def new_import
    current_account.imports.build
  end
end
