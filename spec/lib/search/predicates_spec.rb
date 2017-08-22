require 'rails_helper'

RSpec.describe Search::Predicates do
  subject { Search::Predicates.new(predicates) }

  describe 'call' do
    context 'multiple predicates' do
      let(:predicates) do
        [{ type: 'date', attribute: 'created_at', value: '1', comparison: 'eq' },
         { type: 'integer', attribute: 'messages_count', value: '1', comparison: 'eq' }]
      end

      it 'returns a hash with multiple keys' do
        expect(subject.call.keys.count).to eq(2)
      end
    end

    context 'date predicate' do
      context 'gt comparison' do
        let(:predicates) do
          [{ type: 'date', attribute: 'created_at', value: '1', comparison: 'gt' }]
        end

        it 'makes a key with _gt_days_ago' do
          expect(subject.call[:created_at_gt_days_ago]).to be_present
        end
      end

      context 'eq comparison' do
        let(:predicates) do
          [{ type: 'date', attribute: 'created_at', value: '1', comparison: 'eq' }]
        end

        it 'makes a key with _eq_days_ago' do
          expect(subject.call[:created_at_eq_days_ago]).to be_present
        end
      end

      context 'lt comparison' do
        let(:predicates) do
          [{ type: 'date', attribute: 'created_at', value: '1', comparison: 'lt' }]
        end

        it 'makes a key with _lt_days_ago' do
          expect(subject.call[:created_at_lt_days_ago]).to be_present
        end
      end
    end

    context 'string predicate' do
      context 'cont comparison' do
        let(:predicates) do
          [{ type: 'string', attribute: 'name', value: 'a', comparison: 'cont' }]
        end

        it 'makes a key with _cont' do
          expect(subject.call[:name_cont]).to be_present
        end
      end
    end

    context 'select predicate' do
      let(:predicates) do
        [{ type: 'select', attribute: 'taggings_tag_id', value: '1', comparison: 'eq' }]
      end

      context 'eq comparison' do
        it 'makes a key with _eq' do
          expect(subject.call[:taggings_tag_id_eq]).to be_present
        end
      end
    end

    context 'integer predicate' do
      let(:predicates) do
        [{ type: 'integer', attribute: 'messages_count', value: '1', comparison: 'eq' }]
      end

      context 'eq comparison' do
        it 'makes a key with _eq' do
          expect(subject.call[:messages_count_eq]).to be_present
        end
      end
    end
  end
end
