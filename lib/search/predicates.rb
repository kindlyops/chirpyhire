class Search::Predicates
  def self.call(predicates)
    new(predicates).call
  end

  def initialize(predicates)
    @predicates = predicates
  end

  attr_reader :predicates

  def call
    predicates.map(&method(:to_predicate)).each_with_object(base) do |p, hash|
      hash[p.key] = p.value
    end
  end

  def base
    {}.with_indifferent_access
  end

  def to_predicate(predicate)
    Search::Predicate.new(predicate)
  end
end
