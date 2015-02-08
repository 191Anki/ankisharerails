class AddAttachColumns < ActiveRecord::Migration
  def change
    add_column :decks, :attachment, :string
    add_column :decks, :notes, :string
    add_column :decks, :professor, :string
    add_column :decks, :topic, :string
  end
end
