class Template < ActiveRecord::Base
  belongs_to :organization
  has_one :notice

  def render(user)
    Renderer.call(self, user)
  end
end
