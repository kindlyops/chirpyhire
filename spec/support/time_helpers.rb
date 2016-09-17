# frozen_string_literal: true
module TimeHelpers
  def rand_time(from, to = Time.now)
    Time.at(rand_in_range(from.to_f, to.to_f))
  end

  private

  def rand_in_range(from, to)
    rand * (to - from) + from
  end
end

RSpec.configure do |config|
  config.include TimeHelpers
end
