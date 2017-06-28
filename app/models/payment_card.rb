class PaymentCard < ApplicationRecord
  belongs_to :organization

  def humanized_exp_month
    Date::ABBR_MONTHNAMES[exp_month]
  end
end
