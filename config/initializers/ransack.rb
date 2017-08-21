Ransack.configure do |config|
  config.add_predicate 'lower_eq',
                       arel_predicate: 'eq',
                       formatter: proc { |v| v.downcase },
                       validator: proc { |v| v.present? },
                       type: :string
  config.add_predicate 'gt_days_ago',
                       arel_predicate: 'gt',
                       formatter: proc { |v| v.to_i.days.ago.to_date },
                       validator: proc { |v| v.present? },
                       type: :number
  config.add_predicate 'lt_days_ago',
                       arel_predicate: 'lt',
                       formatter: proc { |v| v.to_i.days.ago.to_date },
                       validator: proc { |v| v.present? },
                       type: :number
  config.add_predicate 'eq_days_ago',
                       arel_predicate: 'eq',
                       formatter: proc { |v| v.to_i.days.ago.to_date },
                       validator: proc { |v| v.present? },
                       type: :number

  config.sanitize_custom_scope_booleans = false
end
