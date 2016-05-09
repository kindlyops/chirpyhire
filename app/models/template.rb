class Template < ActiveRecord::Base
  belongs_to :organization
  has_one :notice
  has_one :question

  def render(person)
    Renderer.call(self, person)
  end
end
