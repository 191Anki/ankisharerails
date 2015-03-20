class RemoveCounter < ActiveRecord::Migration
  def change
    remove_column :decks, :counter
  end
end
