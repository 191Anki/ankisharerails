class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :card_id
      t.string :card_front
      t.string :card_back
      t.string :deck_id

      t.timestamps
    end
  end
end
