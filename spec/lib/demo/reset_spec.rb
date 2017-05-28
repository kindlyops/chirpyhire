require 'rails_helper'

RSpec.describe Demo::Reset do
  include ActiveSupport::Testing::TimeHelpers
  describe '.call' do
    context 'DEMO environment' do
      before do
        allow(Rails.env).to receive(:demo?).and_return(true)
      end

      context 'on Saturday' do
        SATURDAY = 5
        around do |example|
          travel_to DateTime.current.next_week.next_day(SATURDAY) do
            example.run
          end
        end

        it 'loads the schema' do
          expect(Rake::Task).to receive(:[]).with('db:schema:load') { double(invoke: true) }
          allow(Rake::Task).to receive(:[]).with('db:seed') { double(invoke: true) }

          Demo::Reset.call
        end

        it 'seeds the database' do
          allow(Rake::Task).to receive(:[]).with('db:schema:load') { double(invoke: true) }
          expect(Rake::Task).to receive(:[]).with('db:seed') { double(invoke: true) }

          Demo::Reset.call
        end
      end

      context 'not on Saturday' do
        FRIDAY = 4
        around do |example|
          travel_to DateTime.current.next_week.next_day(FRIDAY) do
            example.run
          end
        end

        it 'does not load the schema' do
          expect(Rake::Task).not_to receive(:[]).with('db:schema:load')

          Demo::Reset.call
        end

        it 'does not seed the database' do
          expect(Rake::Task).not_to receive(:[]).with('db:seed')

          Demo::Reset.call
        end
      end
    end

    context 'production environment' do
      before do
        allow(Rails.env).to receive(:demo?).and_return(false)
      end

      it 'does not load the schema' do
        expect(Rake::Task).not_to receive(:[]).with('db:schema:load')
        expect {
          Demo::Reset.call
        }.to raise_error(Demo::Reset::OutsideDemoEnvironment)
      end

      it 'does not seed the database' do
        expect(Rake::Task).not_to receive(:[]).with('db:seed')

        expect {
          Demo::Reset.call
        }.to raise_error(Demo::Reset::OutsideDemoEnvironment)
      end
    end
  end
end
