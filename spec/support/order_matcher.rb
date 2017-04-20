RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    response.body.index(earlier_content) < response.body.index(later_content)
  end
end
