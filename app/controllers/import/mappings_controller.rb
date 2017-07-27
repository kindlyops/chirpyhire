class Import::MappingsController < ApplicationController
  layout 'wizard'

  def update
    if mapping.update(permitted_attributes(ColumnMapping))
      redirect_to next_import_path
    else
      render :edit
    end
  end

  def edit
    mapping
  end

  private

  def next_import_path
    return edit_path if next_mapping.present?

    new_import_csv_tag_path(import)
  end

  def edit_path
    edit_import_csv_mapping_path(import, next_mapping)
  end

  def next_mapping
    import.mapping_after(mapping)
  end

  def mapping
    @mapping ||= authorize import.mappings.find(params[:id])
  end

  def import
    @import ||= begin
      authorize(current_account.imports.find(params[:csv_id]), :show?)
    end
  end

  def build_import
    current_account.imports.build(permitted_attributes(Import))
  end

  def new_import
    current_account.imports.build
  end
end
