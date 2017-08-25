require 'rails_helper'

RSpec.describe Import::Column do
  subject { import.document_columns.first }

  describe '#preview_values' do
    context 'iso-8859-1' do
      let(:import) { create(:import, :iso_8859_1) }

      it 'does not raise an error' do
        expect {
          subject.preview_values
        }.not_to raise_error
      end
    end

    context 'UTF-8' do
      let(:import) { create(:import, :utf_8) }

      it 'does not raise an error' do
        expect {
          subject.preview_values
        }.not_to raise_error
      end
    end
  end
end
