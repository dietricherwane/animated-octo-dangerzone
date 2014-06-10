class AddDisableAccountToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :disable_account, :boolean
  end
end
