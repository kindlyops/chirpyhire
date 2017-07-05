class Survey::Questions
  def self.call(contact)
    new(contact).call
  end

  def initialize(contact)
    @contact = contact
  end

  attr_reader :contact

  def call
    Hash[keys.map do |key|
      klass = :zip_code if key == :zipcode
      klass ||= key
      question = "Question::#{klass.to_s.camelcase}".constantize.new(contact)
      [key, question]
    end].with_indifferent_access
  end

  def keys
    %i[certification availability live_in experience
       transportation drivers_license zipcode cpr_first_aid skin_test]
  end
end
