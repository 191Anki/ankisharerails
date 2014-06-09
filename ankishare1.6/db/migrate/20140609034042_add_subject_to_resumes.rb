class AddSubjectToResumes < ActiveRecord::Migration
  def change
    add_column :resumes, :subject, :string
  end
end
