class Candidates::SegmentsController < ApplicationController
  skip_after_action :verify_authorized, only: %i[show], if: :format_html?
  layout 'react', only: %i[show]

  def show
    respond_to do |format|
      format.html { render html: '', layout: true }
    end
  end

  private
  
  def format_html?
    request.format == 'html'
  end
end
