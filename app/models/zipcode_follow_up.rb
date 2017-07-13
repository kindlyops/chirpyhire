class ZipcodeFollowUp < FollowUp
  def tag(contact)
    tags.find_each do |tag|
      template = Liquid::Template.parse(tag.name)
      parsed_name = template.render('zipcode' => contact.zipcode.zipcode)
      organization_tags = contact.organization.tags
      templated_tag = organization_tags.find_or_create_by(name: parsed_name)
      contact.tags << templated_tag
    end
  end

  def activated?(message)
    Bot::ZipcodeAnswer.new(self).activated?(message)
  end
end
