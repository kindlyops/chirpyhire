RSpec.configure do |config|
  config.before do
    Heap.stubbed = true
  end

  config.after do
    Heap.stubbed = false
  end
end
