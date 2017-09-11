require 'rails_helper'

RSpec.describe Import do
  subject { create(:import, :illegal_quoting) }

  describe '#document_columns' do
    it 'does not raise an error' do
      expect {
        subject.document_columns
      }.not_to raise_error
    end
  end
end
