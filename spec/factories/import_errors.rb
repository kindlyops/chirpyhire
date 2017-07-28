FactoryGirl.define do
  factory :import_error do
    import
    row_number { rand(100) }
    column_number { rand(100) }
    column_name { 'Phone' }
    error_type { :invalid_phone_number }
  end
end
