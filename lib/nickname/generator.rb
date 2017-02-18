module Nickname
  class Generator
    def initialize(person)
      @person = person
      @tried_names = Set.new
    end

    def generate
      raise OutOfNicknames, 'Unable to find new nickname' if exceeded_nicknames?
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

    def exceeded_nicknames?
      Person.count > nickname_count
    end

    def tried?(nickname)
      tried_names.include?(nickname)
    end

    def taken?(nickname)
      exists = Person.exists?(nickname: nickname)
      tried_names.add(nickname) if exists
      exists
    end

    def random_nickname
      "#{ADJECTIVES.sample} #{ANIMALS.sample}"
    end

    attr_reader :person
  end

  CONFIG = YAML.load_file(Rails.root.join('config', 'nicknames.yml'))
  ANIMALS = CONFIG['Animals']
  ADJECTIVES = CONFIG['Adjectives']

  private_constant :ANIMALS, :ADJECTIVES, :CONFIG
end
