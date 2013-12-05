class UpdateTransportOnProfiles < ActiveRecord::Migration
  def up
    Profile.all.each do |profile|
      # ||= doesn't work anymore because of the default value
      profile.transport_type = profile.transport_type
      profile.save!
    end
  end

  def down
  end
end
