class AddClassToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :class, :string
  end
end
