class AddingNewValues < ActiveRecord::Migration
  def change
    add_column :decks, :counter, :integer, :default => 0
    add_column :decks, :user_name, :string
    add_column :users, :student_year, :integer
    add_column :users, :user_name, :string
    add_column :users, :ecounter, :integer, :default => 0
    add_column :users, :ucounter, :integer, :default => 0
    add_column :users, :dcounter, :integer, :default => 0
  end
end
