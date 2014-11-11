class FixClassName2 < ActiveRecord::Migration
  def change
  rename_column :decks, :class_name, :class_name_id
  end
end
