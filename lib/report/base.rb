class Report::Base
  include ActionView::Helpers::TextHelper

  def initialize(account)
    @account = account
  end

  attr_reader :account

  delegate :email, to: :account, prefix: true
  delegate :organization, to: :account

  def subject
    "#{subject_prefix} #{subject_suffix}".squish
  end

  def subject_prefix
    "#{organization.name}: #{pluralize(count, 'candidate')} #{verb}"
  end

  def subject_suffix; end

  def verb
    return 'is' if count == 1
    'are'
  end

  def count; end
end
