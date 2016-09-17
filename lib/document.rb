# frozen_string_literal: true
class Document
  delegate :label, to: :feature

  def initialize(feature)
    @feature = feature
  end

  def first_page
    feature.properties['url0']
  end

  def uris
    feature.properties.select { |k, _| k['url'] }.values
  end

  def additional_uris
    uris.drop(1)
  end

  private

  attr_reader :feature
end
