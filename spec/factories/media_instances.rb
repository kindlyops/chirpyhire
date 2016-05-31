FactoryGirl.define do
  factory :media_instance do
    content_type { %w(image/jpeg image/gif image/png image/bmp).sample }
    uri { '/example/path/to/image '}
    message
    sid { Faker::Number.number(10) }
  end
end
