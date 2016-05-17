class Template < ActiveRecord::Base
  belongs_to :organization
  has_one :notice
  has_one :question

  def render(user)
    Renderer.call(self, user)
  end
end
