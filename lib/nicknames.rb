module Nicknames
  class OutOfNicknamesError < StandardError
  end

  class Generator
    def initialize(candidate)
      @candidate = candidate
      @organization = candidate.organization
      @tried_names = Set.new
    end

    def generate
      raise OutOfNicknamesError, 'Unable to find new nickname' if
            organization.candidates.count > nickname_count
      loop do
        nickname = random_nickname
        return nickname unless tried?(nickname) || taken?(nickname)
      end
    end

    def nickname_count
      ANIMALS.count * ADJECTIVES.count
    end

    attr_reader :tried_names

    private

    def tried?(nickname)
      tried_names.include?(nickname)
    end

    def taken?(nickname)
      exists = organization.candidates.exists?(nickname: nickname)
      tried_names.add(nickname) if exists
      exists
    end

    def random_nickname
      "#{ADJECTIVES.sample} #{ANIMALS.sample}"
    end

    attr_reader :candidate, :organization
  end

  CONFIG = YAML.load_file(Rails.root.join('lib', '.nicknames.yml'))
  ANIMALS = CONFIG['Animals']
  ADJECTIVES = CONFIG['Adjectives']

  private_constant :ANIMALS, :ADJECTIVES, :CONFIG
end
