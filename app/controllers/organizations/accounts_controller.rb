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
      redirect_to person_path, notice: update_notice
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

  def person_path
    organization_person_path(current_organization, @account)
  end

  def update_notice
    "#{@account.name} updated!"
  end
end
