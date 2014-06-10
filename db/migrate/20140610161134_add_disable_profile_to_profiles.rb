class AddDisableProfileToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :disable_profile, :boolean
  end
end
