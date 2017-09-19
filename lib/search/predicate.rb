class Search::Predicate
  def initialize(predicate)
    @predicate = predicate.to_h.with_indifferent_access
  end

  attr_reader :predicate

  def key
    return "#{attribute}_#{comparison}_days_ago" if date?

    "#{attribute}_#{comparison}"
  end

  def value
    return predicate[:value].to_i if integerable?

    predicate[:value]
  end

  def attribute
    predicate[:attribute]
  end

  def comparison
    predicate[:comparison]
  end

  private

  def integerable?
    predicate[:value].respond_to?(:to_i) && !string?
  end

  def string?
    predicate[:type] == 'string'
  end

  def date?
    predicate[:type] == 'date'
  end

  def integer?
    predicate[:type] == 'integer'
  end

  def select?
    predicate[:type] == 'select'
  end
end
