class CreateCampaigns < ActiveRecord::Migration

  def change

    create_table :campaigns do |table|

      table.boolean :need_to_upload, null: false, default: true
      table.column :dirty_attributes, :string, array: true, null: false, default: []
      table.column :data, :json, null: false, default: {}

      table.integer :external_id
      table.string :provider_id

      table.timestamps null: false
    end

  end

end
