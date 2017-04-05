module DropdownHelper
  def dropdown_labels
    klasses.map(&:humanize_attributes).inject(&:merge)
  end

  def dropdown_icons
    klasses.map(&:icon_classes).inject(&:merge)
  end

  private

  def klasses
    [Contact::Certification, Contact::Experience, 
     Contact::Availability, Contact::Transportation]
  end
end
