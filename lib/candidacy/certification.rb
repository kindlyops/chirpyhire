class Candidacy::Certification < Candidacy::Attribute
  def humanize_attributes
    {
      pca: 'PCA',
      cna: 'CNA',
      other_certification: 'RN, LPN, Other',
      no_certification: 'None'
    }.with_indifferent_access
  end

  def icon_classes
    {
      pca: 'fa-heart-o',
      cna: 'fa-heart',
      other_certification: 'fa-heartbeat',
      no_certification: 'fa-graduation-cap'
    }.with_indifferent_access
  end
end
