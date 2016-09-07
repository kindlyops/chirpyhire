class AddDefaultStages < ActiveRecord::Migration[5.0]
  def change
    Organization.ids.each do |id|
      Stage.defaults(organization_id: id).each { |stage| stage.save }
    end
  end
end
