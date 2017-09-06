require 'rails_helper'

RSpec.describe Subscription::Price do
  let!(:subscription) { create(:subscription) }
  subject { Subscription::Price.new(subscription) }

  describe '#call' do
    context 'lots of engaged contacts' do
      [1100, 2100, 3100].each do |number|
        describe number.to_s do
          before do
            allow(subject).to receive(:engaged_contact_count).and_return(number)
          end

          it 'does not raise an error' do
            expect {
              subject.call
            }.not_to raise_error
          end
        end
      end
    end
  end
end
