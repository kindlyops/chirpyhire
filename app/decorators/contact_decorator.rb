class ContactDecorator < Draper::Decorator
  delegate_all

  def hero_pattern_classes
    "#{number_class[id % 9]} #{pattern_class[id % 81]}"
  end

  def joined_at
    Contact::JoinedAt.new(object)
  end

  def last_active_at
    Contact::LastActiveAt.new(object)
  end

  def stats
    Contact::Stats.new(object)
  end

  def created_at
    Contact::CreatedAt.new(object)
  end

  def last_reply_at
    Contact::LastReplyAt.new(object)
  end

  def survey_progress
    Contact::SurveyProgress.new(object)
  end

  def temperature
    Contact::Temperature.new(object)
  end

  def handle
    Contact::Handle.new(object)
  end

  def phone_number
    Contact::PhoneNumber.new(object)
  end

  def availability
    Contact::Availability.new(object)
  end

  def transportation
    Contact::Transportation.new(object)
  end

  def experience
    Contact::Experience.new(object)
  end

  def qualifications
    Contact::Qualifications.new(object)
  end

  def zipcode
    Contact::Zipcode.new(object)
  end

  def certification
    Contact::Certification.new(object)
  end

  def skin_test
    Contact::SkinTest.new(object)
  end

  def cpr_first_aid
    Contact::CprFirstAid.new(object)
  end

  def status
    Contact::Status.new(object)
  end

  def subscribed
    Contact::Subscribed.new(object)
  end

  def screened
    Contact::Screened.new(object)
  end

  def number_class 
    {
      1 => 'first',
      2 => 'second',
      3 => 'third',
      4 => 'fourth',
      5 => 'fifth',
      6 => 'sixth',
      7 => 'seventh',
      8 => 'eighth',
      0 => 'nineth'
    }
  end

  def pattern_class
    Hash[(0..80).zip(pattern_classes)]
  end

  def pattern_classes
    %w(four-point-stars anchors-away architect autumn aztec 
  bamboo bank-note bathroom-floor bevel-circle boxes brick-wall 
  bubbles cage charlie-brown church-on-sunday circles-and-squares 
  circuit-board connections cork-screw current curtain cutout 
  death-star diagonal-lines diagonal-stripes dominos endless-clouds 
  eyes falling-triangles fancy-rectangles flipped-diamonds 
  floating-cogs floor-tile glamorous graph-paper groovy 
  happy-intersection heavy-rain hexagons hideout houndstooth 
  i-like-food intersecting-circles jupiter kiwi leaf line-in-motion 
  lips lisbon melt moroccan morphing-diamonds overlapping-circles 
  overlapping-diamonds overlapping-hexagons parkay-floor piano-man 
  pie-factory pixel-dots plus polka-dots rails rain random-shapes 
  rounded-plus-connected signal slanted-stars squares-in-squares,
   squares stamp-collection steel-beams stripes temple tic-tac-toe 
   tiny-checkers volcano-lamp wallpaper wiggle x-equals yyy zig-zag).map do |c|
    "hp-#{c}"
   end
  end
end
