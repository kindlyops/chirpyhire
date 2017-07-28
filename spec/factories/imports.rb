FactoryGirl.define do
  factory :import do
    account

    trait :id_column_id_present do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_present.csv')) }
    end

    trait :id_column_id_present_valid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_present_valid_phone_number.csv')) }
    end

    trait :id_column_id_present_invalid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_present_invalid_phone_number.csv')) }
    end

    trait :id_column_id_present_missing_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_present_missing_phone_number.csv')) }
    end

    trait :id_column_id_missing_valid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_missing_valid_phone_number.csv')) }
    end

    trait :id_column_id_missing_invalid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_missing_invalid_phone_number.csv')) }
    end

    trait :id_column_id_missing_phone_number_missing do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_missing_phone_number_missing.csv')) }
    end

    trait :no_id_column_valid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'no_id_column_valid_phone_number.csv')) }
    end

    trait :no_id_column_invalid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'no_id_column_invalid_phone_number.csv')) }
    end

    trait :no_id_column_missing_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'no_id_column_missing_phone_number.csv')) }
    end

    trait :multiple do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'multiple.csv')) }
    end
  end
end
