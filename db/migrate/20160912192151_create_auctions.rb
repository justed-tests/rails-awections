class CreateAuctions < ActiveRecord::Migration[5.0]
  def change
    create_table :auctions do |t|
      t.float :value
      t.references :product, foreign_key: true

      t.timestamps
    end
  end
end
