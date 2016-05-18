require 'rails_helper'

RSpec.describe TriggerPresenter do

  subject { TriggerPresenter.new(trigger) }

  describe "#title" do
    context "with question observable" do
      let(:trigger) { create(:trigger, :with_observable) }
      let(:template) { trigger.observable.template }

      it "is Answers a question" do
        expect(subject.title).to eq("Answers a question")
      end
    end

    context "Candidate subscribe trigger" do
      let(:trigger) { create(:trigger, observable_type: "Candidate", event: "subscribe") }

      it "is the type" do
        expect(subject.title).to eq("Subscribes")
      end
    end
  end
end
