class ClassName < ActiveRecord::Base
  # Class names model for filtering
  has_many :decks, :dependent => :nullify
  belongs_to :user

  def self.options_for_select
    order('LOWER(:cname)').map { |e| [e.name, e.id] }
  end

   def self.options_for_sorted_by_1
     #@user = User.find(current_user)
     if user.student_year == 2
      [
        ['Anatomy & Embryology', 'Anatomy & Embryology'],
        ['Neurosciences', 'Neurosciences'],
        ['Histology', 'Histology']
      ]
     else
      [
        ['Anatomy & Embryology', 'Anatomy & Embryology'],
        ['Neurosciences', 'Neurosciences'],
        ['Mistology', 'Histology']
      ]
    end
  end
end
