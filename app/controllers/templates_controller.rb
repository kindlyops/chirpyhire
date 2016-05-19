class TemplatesController < ApplicationController

  def index
    @templates = templates
  end

  private

  def templates
    policy_scope Template
  end
end
