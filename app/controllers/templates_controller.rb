class TemplatesController < ApplicationController
  def index
    @templates = templates
  end

  private

  def templates
    organization.templates
  end
end
