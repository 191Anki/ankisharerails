class CreateDecks < ActiveRecord::Migration
  def change
    create_table :decks do |t|
      t.string "author"
      t.string "class"
      t.string "year"
      t.timestamps
    end
  end
end
