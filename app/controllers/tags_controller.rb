class TagsController < ApplicationController
  def index
    @tags = policy_scope(Tag)

    respond_to do |format|
      format.json
    end
  end
end
