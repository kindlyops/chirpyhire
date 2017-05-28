class Demo::Reset
  def self.call
    # raise "Cannot run task outside demo environment" unless Rails.env.demo?

    ActiveRecord::Base.connection.tables.each do |table|
      if table != 'schema_migrations'
        query = "DROP TABLE IF EXISTS #{table} CASCADE;"
        ActiveRecord::Base.connection.execute(query)
      end
    end
  end
end
