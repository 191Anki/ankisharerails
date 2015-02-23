class AddDeckIdToDecks < ActiveRecord::Migration
  def change
    add_column :decks, :deck_id, :integer
  end
end
