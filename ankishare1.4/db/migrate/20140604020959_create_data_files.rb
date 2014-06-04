class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.string :front
      t.string :back
      t.string :card_id
      t.timestamps
    end
  end
end
