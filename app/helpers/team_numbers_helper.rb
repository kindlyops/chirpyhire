module TeamNumbersHelper
  def team_numbers(account)
    team_numbers = to_team_numbers(account)
    team_numbers.join("\n")
  end

  private

  def to_team_numbers(account)
    account.teams.pluck(:name, :phone_number).map do |name, phone_number|
      "#{name}: #{phone_number.phony_formatted}"
    end
  end
end
