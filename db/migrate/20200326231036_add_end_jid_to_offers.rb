class AddEndJidToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :end_jid, :string
  end
end
