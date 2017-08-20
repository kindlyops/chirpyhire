class Zipcode < ApplicationRecord
  has_many :people
  has_many :contacts

  ransacker :zipcode, type: :string do
    Arel.sql('lower(zipcode)')
  end

  ransacker :state_abbreviation, type: :string do
    Arel.sql('lower(state_abbreviation)')
  end

  ransacker :county_name, type: :string do
    Arel.sql('lower(county_name)')
  end

  ransacker :default_city, type: :string do
    Arel.sql('lower(default_city)')
  end
end
