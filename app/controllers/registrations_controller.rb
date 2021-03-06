class RegistrationsController < Devise::RegistrationsController
  def new
    super do |account|
      account.build_organization
      account.build_person
    end
  end

  def create
    super { |account| Registrar.new(account, referrer).register }
  end

  private

  def referrer
    Account.find_by(affiliate_tag: affiliate_tag) if affiliate_tag.present?
  end

  def affiliate_tag
    request.env['affiliate.tag']
  end

  def sign_up_params
    params.require(resource_name).permit(attributes)
  end

  def attributes
    account_attributes
      .push(organization_attributes: organization_attributes_keys)
  end

  def after_sign_up_path_for(*)
    recruiting_ads_path
  end

  def account_attributes
    %i[email password agreed_to_terms phone_number name]
  end

  def organization_attributes_keys
    %i[name size].push(teams_attributes: teams_attributes)
  end

  def teams_attributes
    %i[name].push(location_attributes: location_attributes)
  end

  def location_attributes
    %i[full_street_address
       latitude
       longitude
       city
       state
       state_code
       postal_code
       country
       country_code]
  end

  def organization_attributes
    params[:account][:organization_attributes]
  end
end
