class AddDeckColumns < ActiveRecord::Migration
  def change
    add_column :decks, :author, :string
    add_column :decks, :class, :string
    add_column :decks, :year, :string
  end
end
