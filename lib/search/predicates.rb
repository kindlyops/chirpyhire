class Search::Predicates
  def self.call(predicates)
    new(predicates).call
  end

  def initialize(predicates)
    @predicates = predicates.map(&method(:to_predicate))
  end

  attr_reader :predicates

  def call
    predicates.chunk(&:key).each_with_object(base) do |(key, chunk), hash|
      paragon = chunk.first

      if chunk.count > 1 && %w[eq not_eq].include?(paragon.comparison)
        hash[multiple_key(paragon)] = multiple_value(chunk)
      else
        chunk.each do |predicate|
          hash[predicate.key] = predicate.value
        end
      end
    end
  end

  def multiple?(predicates)
    multiples(predicates).count > 1
  end

  def multiples(predicates)
    predicates.select { |p| p.attribute == attribute }
  end

  def multiple_key(paragon)
    multiple_comparison = 'not_in' if paragon.comparison == 'not_eq'
    multiple_comparison ||= 'in' if paragon.comparison == 'eq'

    "#{paragon.attribute}_#{multiple_comparison}"
  end

  def multiple_value(chunk)
    chunk.map(&:value)
  end

  def base
    {}.with_indifferent_access
  end

  def to_predicate(predicate)
    Search::Predicate.new(predicate)
  end
end
