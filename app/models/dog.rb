class Dog < Animal
  has_paper_trail
  has_many :toys, foreign_key: :animal_id, inverse_of: :dog
  accepts_nested_attributes_for :toys
end
