class CreateOpportunities < ActiveRecord::Migration[6.1]
  def change
    create_table :opportunities do |t|
      t.string :title
      t.text :description
      t.integer :salary
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
