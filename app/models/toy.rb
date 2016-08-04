class Toy < ApplicationRecord
  has_paper_trail
  belongs_to :dog, class_name: "Dog", foreign_key: :animal_id, inverse_of: :toys
end
