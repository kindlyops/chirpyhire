module HeroPatternable
  extend ActiveSupport::Concern

  included do
    def hero_pattern_classes
      "#{number_class[id % 9]} #{pattern_class[id % 81]}"
    end

    def number_class
      Hash[(0..8).zip(number_classes)]
    end

    def number_classes
      %w(first second third fourth fifth sixth seventh eighth nineth)
    end

    PATTERNS = YAML.load_file(Rails.root.join('config', 'hero_patterns.yml'))
    def pattern_class
      Hash[(0..80).zip(PATTERNS)]
    end
  end
end
