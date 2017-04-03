class Contact::Filterer
  def initialize(params)
    @params = params
    @filters = filter_options.select { |f| @params[f].present? }
    @case_clause = 'CASE'
  end

  def order
    return { id: :asc } unless filters.present?
    filters.count.times(&method(:build_order))
    case_clause
  end

  private

  def filter_options
    [:zipcode, :availability, :certification, :experience, :transportation]
  end

  def build_order(time)
    case_clause << ' WHEN (' << build_when_fragment(time) << end_fragment(time)
  end

  def build_when_fragment(time)
    possible_matches = combinations(time).each_with_object('')
    possible_matches.with_index do |(combination, filter_fragment), c|
      combination.each_with_index do |filter, f|
        count = combination.count

        filter_fragment << " candidacies.#{filter}='#{filter_mapping(filter)}'"
        filter_fragment << filter_postlude(f, c, count, time)
      end
    end
  end

  def filter_mapping(filter)
    return params[filter] if filter == :zipcode
    Candidacy.send(filter.to_s.pluralize)[params[filter]]
  end

  def combinations(time)
    filters.combination(filters.count - time)
  end

  def last_time?(time)
    time == (filters.count - 1)
  end

  def filter_postlude(f, c, count, time)
    if intermediate_filter?(f, count)
      ' AND'
    elsif intermediate_combination?(f, c, count)
      ') OR ('
    else
      ") THEN #{time}"
    end
  end

  def last_filter?(f, combination_count)
    f == (combination_count - 1)
  end

  def intermediate_filter?(f, combination_count)
    f < (combination_count - 1)
  end

  def intermediate_combination?(f, c, combination_count)
    last_filter?(f, combination_count) && c < (combination_count - 1)
  end

  attr_reader :filters, :params
  attr_accessor :case_clause

  def stabilizer
    ', contact.id ASC'
  end

  def end_fragment(time)
    return '' unless last_time?(time)
    " ELSE #{time + 1} END as match#{stabilizer}"
  end
end
