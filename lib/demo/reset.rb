class Demo::Reset
  SATURDAY = 6

  def self.call
    raise OutsideDemoEnvironment unless Rails.env.demo?
    return unless Date.current.wday == SATURDAY

    Rake::Task['db:schema:load'].invoke
    Rake::Task['db:seed'].invoke
  end

  OutsideDemoEnvironment = Class.new(StandardError)
end
