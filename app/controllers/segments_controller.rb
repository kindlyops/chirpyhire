class SegmentsController < ApplicationController
  def index
    @segments = policy_scope(current_account.segments)

    respond_to do |format|
      format.json
    end
  end

  def create
    @segment = authorize new_segment
    @segment.save
    
    respond_to do |format|
      format.json
    end
  end

  private

  def new_segment
    current_account.segments.build(new_segment_attributes)
  end

  def new_segment_attributes
    permitted_attributes(Segment).merge(account: current_account)
  end
end
