FactoryGirl.define do
  factory :import do
    account

    after(:create) do |import|
      Import::Create.call(import)
    end

    trait :id_column_id_present_valid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_present_valid_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'id').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 1)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 2)
      end
    end

    trait :id_column_id_present_invalid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_present_invalid_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'id').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 1)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 2)
      end
    end

    trait :id_column_id_present_missing_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_present_missing_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'id').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 1)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 2)
      end
    end

    trait :id_column_id_missing_valid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_missing_valid_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'id').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 1)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 2)
      end
    end

    trait :id_column_id_missing_invalid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_missing_invalid_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'id').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 1)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 2)
      end
    end

    trait :id_column_id_missing_phone_number_missing do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'id_column_id_missing_phone_number_missing.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'id').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 1)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 2)
      end
    end

    trait :no_id_column_valid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'no_id_column_valid_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 1)
      end
    end

    trait :no_id_column_invalid_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'no_id_column_invalid_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 1)
      end
    end

    trait :no_id_column_missing_phone_number do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'no_id_column_missing_phone_number.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 1)
      end
    end

    trait :multiple do
      document { File.new(Rails.root.join('spec', 'support', 'fixtures', 'multiple.csv')) }

      after(:create) do |import|
        import.mappings.find_by(contact_attribute: 'phone_number').update(column_number: 0)
        import.mappings.find_by(contact_attribute: 'name').update(column_number: 1)
      end
    end
  end
end
