require 'rails_helper'

RSpec.describe CandidatesController, type: :controller do
  let(:organization) { create(:organization, :with_subscription, :with_account) }
  let(:account) { organization.accounts.first }
  let(:user) { account.user }

  before(:each) do
    sign_in(account)
  end

  describe '#show' do
    let(:user) { create(:user, organization: organization) }
    let(:candidate) { create(:candidate, user: user) }
    context 'geojson' do
      it 'is OK' do
        get :show, params: { id: candidate.id, format: 'geojson' }
        expect(response).to be_ok
      end
    end
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
                 stage: organization.qualified_stage,
                 created_at: rand_time(24.hours.ago),
                 organization: organization)
        end
      end

      let!(:past_week_candidates) do
        Array.new(2) do
          create(:candidate,
                 stage: organization.qualified_stage,
                 created_at: rand_time(1.week.ago, 25.hours.ago),
                 organization: organization)
        end
      end

      let!(:past_month_candidates) do
        Array.new(2) do
          create(:candidate,
                 stage: organization.qualified_stage,
                 created_at: rand_time(1.month.ago, 8.days.ago),
                 organization: organization)
        end
      end

      let!(:beyond_month_candidates) do
        Array.new(2) do
          create(:candidate,
                 stage: organization.qualified_stage,
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

    context 'with zipcode filter' do
      let(:zipcodes) { %w(30342 30305 30307) }
      let!(:no_address_or_zipcode_candidates) do
        Array.new(3) do
          create(:candidate,
                 stage: organization.qualified_stage,
                 organization: organization)
        end
      end

      let!(:zipcode_candidates) do
        zipcodes.map do |zipcode|
          create(:candidate,
                 stage: organization.qualified_stage,
                 organization: organization,
                 zipcode: zipcode)
        end
      end

      let!(:address_candidates) do
        %w(12345 30305).map do |zipcode|
          create(:candidate,
                 :with_address,
                 stage: organization.qualified_stage,
                 organization: organization,
                 address_zipcode: zipcode)
        end
      end

      it 'includes everyone' do
        get :index, params: { created_in: 'All Time', zipcode: CandidateFeature::ALL_ZIPCODES_CODE }
        expect(assigns(:candidates)).to include(*no_address_or_zipcode_candidates)
        expect(assigns(:candidates)).to include(*zipcode_candidates)
        expect(assigns(:candidates)).to include(*address_candidates)
      end

      it 'excludes candidates without a zipcode' do
        get :index, params: { created_in: 'All Time', zipcode: '30342' }
        expect(assigns(:candidates)).to include(zipcode_candidates[0])
        expect(assigns(:candidates)).not_to include(*address_candidates)
        expect(assigns(:candidates)).not_to include(*no_address_or_zipcode_candidates)
      end

      it 'includes candidates with an address that matches the zipcode' do
        get :index, params: { created_in: 'All Time', zipcode: '30305' }
        expect(assigns(:candidates)).to include(zipcode_candidates[1])
        expect(assigns(:candidates)).to include(address_candidates[1])
        expect(assigns(:candidates)).not_to include(*no_address_or_zipcode_candidates)
        expect(assigns(:candidates)).not_to include(address_candidates[0])
        expect(assigns(:candidates)).not_to include(zipcode_candidates[0], zipcode_candidates[2])
      end
    end

    context 'with candidates' do
      let(:qualified_stage) { organization.qualified_stage }
      let!(:candidates) { create_list(:candidate, 3, stage: qualified_stage, organization: organization) }

      context 'geojson' do
        context 'with candidates with addresses without phone numbers' do
          let!(:candidates) { create_list(:candidate, 3, :with_address, stage: qualified_stage, organization: organization) }
          it 'is OK' do
            allow_any_instance_of(CandidatesController).to receive(:state_data).and_return(FakeStateData.new)
            get :index, format: :geojson
            expect(response).to be_ok
          end
        end
      end

      it "returns the organization's candidates" do
        get :index
        expect(assigns(:candidates)).to match_array(candidates)
      end

      it 'can change a candidates stage' do
        get :update, params: { id: organization.candidates.first.id, candidate: { stage_id: organization.bad_fit_stage.id } }
        expect(qualified_stage.candidates.count).to eq(2)
        expect(organization.bad_fit_stage.candidates.count).to eq(1)
      end

      context 'order' do
        let(:potential_stage) { organization.potential_stage }
        let!(:old_candidate) { create(:candidate, id: 15, stage: potential_stage, organization: organization) }
        let!(:recent_candidate) { create(:candidate, id: 16, stage: potential_stage, organization: organization) }

        it 'returns the most recent candidates first' do
          get :index, params: { stage_name: potential_stage.name }
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
