module Nicknames
  class OutOfNicknamesError < StandardError
  end

  class Generator
    def initialize(candidate)
      @candidate = candidate
      @organization = candidate.organization
    end

    def generate
      raise OutOfNicknamesError.new('Unable to find new nickname') if
            organization.candidates.count > nickname_count
      loop do
        nickname = random_nickname
        return nickname unless taken?(nickname)
      end
    end

    def nickname_count
      ANIMALS.count * ADJECTIVES.count
    end

    private

    def taken?(nickname)
      organization.candidates.exists?(nickname: nickname)
    end

    def random_nickname
      "#{ADJECTIVES.sample} #{ANIMALS.sample}"
    end

    attr_reader :candidate, :organization
  end

  CONFIG = YAML.load_file("#{Rails.root.to_s}/lib/.nicknames.yml")
  ANIMALS = CONFIG['Animals']
  ADJECTIVES = CONFIG['Adjectives']

  private_constant :ANIMALS, :ADJECTIVES, :CONFIG
end
