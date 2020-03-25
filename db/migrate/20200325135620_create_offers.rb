class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.string :advertiser_name, null: false
      t.string :url, null: false
      t.text :description, null: false
      t.datetime :starts_at, null: false
      t.datetime :ends_at
      t.boolean :premium
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
