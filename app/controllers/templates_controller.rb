class TemplatesController < ApplicationController

  def index
    @templates = templates.decorate
  end

  def preview
    respond_to do |format|
      format.js {
        render text: authorized_template.render(recipient)
      }
    end
  end

  private

  def authorized_template
    authorize Template.find(params[:template_id])
  end

  def recipient
    @recipient ||= begin
      recipient = User.find(params[:user_id])
      if UserPolicy.new(current_account, recipient).show?
        recipient
      else
        raise Pundit::NotAuthorizedError
      end
    end
  end

  def templates
    policy_scope Template
  end
end
