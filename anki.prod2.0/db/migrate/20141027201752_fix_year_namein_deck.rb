class FixYearNameinDeck < ActiveRecord::Migration
  def change
    rename_column :decks, :year, :year_id
    rename_column :decks, :topic, :topic_id
    rename_column :decks, :professor, :professor_id
  end
end
