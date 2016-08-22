class CandidateAdvancerJob < ApplicationJob
  def perform(user)
    CandidateAdvancer.call(user)
  end
end
