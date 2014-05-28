class AddRightsToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :create_user, :boolean
    add_column :profiles, :edit_user_data, :boolean
    add_column :profiles, :view_transactions, :boolean
  end
end
