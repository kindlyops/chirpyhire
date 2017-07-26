class Import::CsvsController < ApplicationController
  def new
    @import = new_import
  end

  private

  def new_import
    current_account.imports.build
  end
end
