class ScenesController < ApplicationController
  skip_after_action :verify_authorized, only: :show

  def show
    render text: scene
  end

  private

  def scene
    ERB.new(File.read(File.join(Rails.root, 'config', 'cinnabar-style.yml.erb'))).result
  end
end
