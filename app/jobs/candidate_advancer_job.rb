# frozen_string_literal: true
class CandidateAdvancerJob < ApplicationJob
  def perform(user)
    CandidateAdvancer.call(user)
  end
end
