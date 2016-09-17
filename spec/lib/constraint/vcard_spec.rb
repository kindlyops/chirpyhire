# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Constraint::Vcard do
  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { described_class.new }

  before do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe '#matches?' do
    context 'without a vcard MediaContentType' do
      let(:parameters) { { 'MediaContentType0' => 'image/jpeg' } }

      it 'is false' do
        expect(constraint.matches?(request)).to eq(false)
      end
    end

    context 'with a text/vcard MediaContentType' do
      let(:parameters) { { 'MediaContentType0' => 'text/vcard' } }

      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end

      context 'with other MediaContentTypes as well' do
        let(:parameters) { { 'MediaContentType0' => 'text/vcard', 'MediaContentType1' => 'image/jpeg' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end
    end

    context 'with a text/x-vcard MediaContentType' do
      let(:parameters) { { 'MediaContentType0' => 'text/x-vcard' } }

      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end

      context 'with other MediaContentTypes as well' do
        let(:parameters) { { 'MediaContentType0' => 'text/x-vcard', 'MediaContentType1' => 'image/jpeg' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end
    end

    context 'with a text/directory;profile=vCard MediaContentType' do
      let(:parameters) { { 'MediaContentType0' => 'text/directory;profile=vCard' } }

      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end

      context 'with other MediaContentTypes as well' do
        let(:parameters) { { 'MediaContentType0' => 'text/directory;profile=vCard', 'MediaContentType1' => 'image/jpeg' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end
    end

    context 'with a text/directory MediaContentType' do
      let(:parameters) { { 'MediaContentType0' => 'text/directory' } }

      it 'is true' do
        expect(constraint.matches?(request)).to eq(true)
      end

      context 'with other MediaContentTypes as well' do
        let(:parameters) { { 'MediaContentType0' => 'text/directory', 'MediaContentType1' => 'image/jpeg' } }

        it 'is true' do
          expect(constraint.matches?(request)).to eq(true)
        end
      end
    end
  end
end
