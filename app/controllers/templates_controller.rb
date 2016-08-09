class TemplatesController < ApplicationController
  def update
    @template = authorized_template

    if @template.update(permitted_attributes(Template))
      redirect_to survey_path, notice: "Nice! Template saved."
    else
      render :edit
    end
  end

  def edit
    @template = authorized_template
  end

  def authorized_template
    authorize Template.find(params[:id])
  end
end
