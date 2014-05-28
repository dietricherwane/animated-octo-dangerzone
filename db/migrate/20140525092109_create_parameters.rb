class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :back_office_url
      t.string :emission_authentication_token
      t.string :reception_authentication_token
      t.string :hubs_back_office

      t.timestamps      
    end
  end
end
