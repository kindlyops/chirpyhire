class Contact::Filterer
  def initialize(params)
    @params = params
  end

  def order
    filters = filter_options.select { |f| params[f].present? }
    return { id: :asc } unless filters.present?

    case_clause = 'CASE'
    filters.count.times do |time|
      when_fragment = ' WHEN ('
      combinations = filters.combination(filters.count - time)
      combinations.each_with_index do |combination, c_index|
        combination.each_with_index do |filter, f_index|
          last_filter = f_index == (combination.count - 1)
          end_of_combination = last_filter && (c_index < combinations.count - 1)
          end_of_filter = f_index < combination.count - 1

          filter_fragment = " candidacies.#{filter}='#{filter_mapping(filter)}'"
          filter_fragment << if end_of_filter
                               ' AND'
                             elsif end_of_combination
                               ') OR ('
                             else
                               ") THEN #{time}"
                             end

          when_fragment << filter_fragment
        end
      end
      end_fragment = " ELSE #{time + 1} END as match#{stabilizer}"
      when_fragment << end_fragment if time == (filters.count - 1)
      case_clause << when_fragment
    end
    case_clause
  end

  private

  def filter_options
    [:zipcode, :availability, :certification, :experience, :transportation]
  end

  def filter_mapping(filter)
    return params[filter] if filter == :zipcode
    Candidacy.send(filter.to_s.pluralize)[params[filter]]
  end

  attr_reader :params

  def stabilizer
    ', contact.id ASC'
  end
end
