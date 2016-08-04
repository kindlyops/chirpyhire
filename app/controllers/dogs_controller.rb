class DogsController < QuestionsController
  skip_before_action :authenticate_account!

  def update
    if authorized_dog.update(permitted_attributes(Dog).merge(updated_at: Time.current))
      redirect_to candidates_url, notice: "Nice! Dog saved."
    else
      render :edit
    end
  end

  private

  def authorized_dog
    authorize Dog.find(params[:id])
  end
end
