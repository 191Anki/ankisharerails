class FixTopicsName < ActiveRecord::Migration
  def change
    rename_column :topics, :name, :topic_name
  end
end
