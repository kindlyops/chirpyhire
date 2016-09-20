require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before(:each) do
    sign_in(account)
  end

  describe '#index' do
    it 'is OK' do
      get :index
      expect(response).to be_ok
    end

    context 'with period filter' do
      let!(:past_24_hour_candidates) do
        Array.new(2) do
          create(:candidate,
                 status: 'Qualified',
                 created_at: rand_time(24.hours.ago),
                 organization: organization)
        end
      end

      let!(:past_week_candidates) do
        Array.new(2) do
          create(:candidate,
                 status: 'Qualified',
                 created_at: rand_time(1.week.ago, 25.hours.ago),
                 organization: organization)
        end
      end

      let!(:past_month_candidates) do
        Array.new(2) do
          create(:candidate,
                 status: 'Qualified',
                 created_at: rand_time(1.month.ago, 8.days.ago),
                 organization: organization)
        end
      end

      let!(:beyond_month_candidates) do
        Array.new(2) do
          create(:candidate,
                 status: 'Qualified',
                 created_at: rand_time(6.months.ago, 35.days.ago),
                 organization: organization)
        end
      end

      context 'past 24 hours' do
        it 'excludes candidates created later than 24 hours ago' do
          get :index, params: { created_in: 'Past 24 Hours' }
          expect(assigns(:candidates)).not_to include(*past_week_candidates)
          expect(assigns(:candidates)).not_to include(*past_month_candidates)
          expect(assigns(:candidates)).not_to include(*beyond_month_candidates)
        end

        it 'includes all candidates created in the past 24 hours' do
          get :index, params: { created_in: 'Past 24 Hours' }
          expect(assigns(:candidates)).to include(*past_24_hour_candidates)
        end
      end

      context 'past week' do
        it 'excludes candidates created later than a week ago' do
          get :index, params: { created_in: 'Past Week' }
          expect(assigns(:candidates)).not_to include(*past_month_candidates)
          expect(assigns(:candidates)).not_to include(*beyond_month_candidates)
        end

        it 'includes all candidates created in the past week' do
          get :index, params: { created_in: 'Past Week' }
          expect(assigns(:candidates)).to include(*past_24_hour_candidates)
          expect(assigns(:candidates)).to include(*past_week_candidates)
        end
      end

      context 'past month' do
        it 'excludes candidates created later than a month ago' do
          get :index, params: { created_in: 'Past Month' }
          expect(assigns(:candidates)).not_to include(*beyond_month_candidates)
        end

        it 'includes all candidates created in the past month' do
          get :index, params: { created_in: 'Past Month' }
          expect(assigns(:candidates)).to include(*past_24_hour_candidates)
          expect(assigns(:candidates)).to include(*past_week_candidates)
          expect(assigns(:candidates)).to include(*past_month_candidates)
        end
      end

      context 'all time' do
        it 'includes all candidates' do
          get :index, params: { created_in: 'All Time' }
          expect(assigns(:candidates)).to include(*past_24_hour_candidates)
          expect(assigns(:candidates)).to include(*past_week_candidates)
          expect(assigns(:candidates)).to include(*past_month_candidates)
          expect(assigns(:candidates)).to include(*beyond_month_candidates)
        end
      end
    end

    context 'with candidates' do
      let!(:candidates) { create_list(:candidate, 3, status: 'Qualified', organization: organization) }

      context 'geojson' do
        context 'with candidates with addresses without phone numbers' do
          let!(:candidates) { create_list(:candidate, 3, :with_address, status: 'Qualified', organization: organization) }

          it 'is OK' do
            get :index, format: :geojson
            expect(response).to be_ok
          end
        end
      end

      it "returns the organization's candidates" do
        get :index
        expect(assigns(:candidates)).to match_array(candidates)
      end

      context 'order' do
        let!(:old_candidate) { create(:candidate, id: 10, organization: organization) }
        let!(:recent_candidate) { create(:candidate, id: 11, organization: organization) }

        it 'returns the most recent candidates first' do
          get :index, params: { status: 'Potential' }
          expect(assigns(:candidates)).to eq([recent_candidate, old_candidate])
        end
      end

      context 'with other organizations' do
        let!(:other_candidates) { create_list(:candidate, 2) }
        it "does not return the other organization's candidates" do
          get :index
          expect(assigns(:candidates)).not_to include(other_candidates)
        end
      end
    end
  end
end
