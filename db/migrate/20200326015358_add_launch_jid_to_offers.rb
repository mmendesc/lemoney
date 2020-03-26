class AddLaunchJidToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :launch_jid, :string
  end
end
