class JobsController < ApplicationController
  skip_before_action :authenticate_account!
  skip_after_action :verify_authorized
  layout 'public'

  def show
    @candidate = organization.contacts.new
  end

  def create
    @candidate = new_contact

    if @candidate.valid?
      @candidate.person = Person.create
      @candidate.subscribed = true
      @candidate.save
      redirect_to candidate_thanks_path(@candidate)
    else
      render :show
    end
  end

  private

  def new_contact
    organization.contacts.build(candidate_attributes)
  end

  def candidate_attributes
    params.require(:contact)
          .permit(:referrer, :name, :phone_number)
          .merge(stage: potential_stage)
  end

  def potential_stage
    organization.contact_stages.find_by(name: 'Potential')
  end

  def organization
    @organization ||= Organization.find(params[:organization_id])
  end
end
