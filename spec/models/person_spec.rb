require 'rails_helper'

RSpec.describe Person do
  describe '#nickname' do
    context 'with a name' do
      subject { create(:person, name: 'Foo') }

      it 'is not present' do
        expect(subject.nickname).not_to be_present
      end
    end

    context 'without a name' do
      subject { create(:person) }

      it 'is present' do
        expect(subject.nickname).to be_present
      end
    end
  end
end
