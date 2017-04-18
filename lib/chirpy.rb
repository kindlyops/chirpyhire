class Chirpy
  def self.person
    Person.find_or_create_by(name: 'Chirpy')
  end
end
