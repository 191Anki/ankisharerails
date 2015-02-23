class FixDeckIdCards < ActiveRecord::Migration
  def change
	change_column :cards, :deck_id, :integer, limit: nil
  end
end
