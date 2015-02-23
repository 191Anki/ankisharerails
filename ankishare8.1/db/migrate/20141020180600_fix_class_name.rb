class FixClassName < ActiveRecord::Migration
  def change
    rename_column :decks, :class, :class_name
  end
end
