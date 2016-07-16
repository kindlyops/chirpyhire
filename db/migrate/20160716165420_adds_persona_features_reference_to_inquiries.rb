class AddsPersonaFeaturesReferenceToInquiries < ActiveRecord::Migration[5.0]
  def change
    add_reference :inquiries, :persona_feature, foreign_key: true
  end
end
