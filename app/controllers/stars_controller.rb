class StarsController < ApplicationController
  def create
    contact.update(starred: !contact.starred)
    handle_star_tag

    Broadcaster::Contact.broadcast(contact)
    head :ok
  end

  private

  def handle_star_tag
    if tagging.present?
      tagging.destroy
    else
      contact.taggings.create(tag: star_tag)
    end
  end

  def tagging
    @tagging ||= contact.taggings.find_by(tag: star_tag)
  end

  def star_tag
    current_organization.tags.find_or_create_by(name: 'Star')
  end

  def contact
    @contact ||= authorize Contact.find(params[:contact_id])
  end
end
