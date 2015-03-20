class AddCounterDecks < ActiveRecord::Migration
  def change
    add_column :decks, :counter, :integer, :default => 0
  end
end
