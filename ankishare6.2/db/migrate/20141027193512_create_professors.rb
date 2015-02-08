class CreateProfessors < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.string :prof_name

      t.timestamps
    end
  end
end
