module Payola
  class SubscriptionsController < Payola::ApplicationController
    def show_object(object_class)
      subscription = object_class.find_by!(guid: params[:guid])

      redirect_to edit_subscription_path(subscription), notice: "Nice! Your subscription is updated."
    end
  end
end
