Ransack.configure do |config|
  config.add_predicate 'lower_eq',
  arel_predicate: 'eq',
  formatter: proc { |v| v.downcase },
  validator: proc { |v| v.present? },
  type: :string
end
