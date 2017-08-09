module HeroPatternable
  extend ActiveSupport::Concern

  included do
    def hero_pattern_classes
      number_class[id % 9].to_s
    end

    def number_class
      Hash[(0..8).zip(number_classes)]
    end

    def number_classes
      %w[first second third fourth fifth sixth seventh eighth nineth]
    end
  end
end
