class AddNotUnderstoodCountToInquiry < ActiveRecord::Migration[5.0]
  def change
    add_column(
      :inquiries,
      :not_understood_count,
      :integer,
      null: false,
      default: 0
    )
  end
end
