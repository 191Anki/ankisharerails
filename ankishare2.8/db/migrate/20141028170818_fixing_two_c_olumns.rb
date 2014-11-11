class FixingTwoCOlumns < ActiveRecord::Migration
  def change
    rename_column :decks, :class_name_id, :cname_id
    rename_column :decks, :professor_id, :prof_id
  end
end
