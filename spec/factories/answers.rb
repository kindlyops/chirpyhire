# frozen_string_literal: true
FactoryGirl.define do
  factory :answer do
    inquiry
    message

    trait :to_document_question do
      association :inquiry, :document_question
    end
  end
end
