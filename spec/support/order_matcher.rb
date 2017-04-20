RSpec::Matchers.define :have_ordered do |*args|
  match do |text|
    args.each_cons(2).all? do |earlier_content, later_content|
      text.index(earlier_content) < text.index(later_content)
    end
  end
end
