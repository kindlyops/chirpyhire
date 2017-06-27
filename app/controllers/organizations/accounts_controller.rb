class Organizations::AccountsController < OrganizationsController
  def index
    @accounts = policy_scope(organization.accounts)
  end

  def show
    @account = authorize Account.find(params[:id])
  end

  def update
    @account = authorize Account.find(params[:id])

    if @account.update(permitted_attributes(Account))
      redirect_to organization_people_path(organization), notice: update_notice
    else
      render :show
    end
  end

  private

  def fetch_organization
    @organization ||= authorize(Organization.find(params[:organization_id]))
  end

  def organization
    @organization ||= begin
      authorize(Organization.find(params[:organization_id]), :show?)
    end
  end

  def update_notice
    "#{@account.name} updated!"
  end
end
