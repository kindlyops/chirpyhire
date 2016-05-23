class TemplatesController < ApplicationController

  def index
    @templates = templates.decorate
  end

  private

  def templates
    policy_scope Template
  end
end
