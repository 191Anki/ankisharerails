class Professor < ActiveRecord::Base
  # Professor name model for filtering
  has_many :decks, :dependent => :nullify

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

end
