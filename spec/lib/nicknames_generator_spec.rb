require 'rails_helper'

RSpec.describe Nicknames::Generator do
  let!(:user) { create(:user, :with_candidate) }
  let!(:candidate) { user.candidate }

  describe '#generate' do
    it 'generates a nickname' do
      nickname = Nicknames::Generator.new(candidate).generate
      expect(nickname).not_to be(nil)
    end

    it 'should not generate the same name as another candidate' do
      generator = Nicknames::Generator.new(candidate)
      allow(generator).to receive(:random_nickname).exactly(2).times
        .and_return(candidate.nickname, 'Dumb Bunny')
      expect(generator.generate).to eq('Dumb Bunny')
      expect(generator.send(:tried_names)
        .include?(candidate.nickname)).to eq(true)
    end

    it 'should not rehit the database when randomly generating a dup' do
      generator = Nicknames::Generator.new(candidate)
      allow(generator).to receive(:random_nickname).exactly(2).times
        .and_return(candidate.nickname, 'Dumb Bunny')
      generator.generate
      expect(generator.send(:tried_names)
        .include?(candidate.nickname)).to eq(true)
    end

    it 'should eventually throw an error when running out of nicknames' do
      generator = Nicknames::Generator.new(candidate)
      allow(generator).to receive(:nickname_count).and_return(0)
      expect {
        generator.generate
      }.to raise_error(Nicknames::OutOfNicknamesError)
    end
  end
end
