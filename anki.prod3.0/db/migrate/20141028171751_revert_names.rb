class RevertNames < ActiveRecord::Migration
  def change
    rename_column :decks, :cname_id, :class_name_id
    rename_column :decks, :prof_id, :professor_id
  end
end
