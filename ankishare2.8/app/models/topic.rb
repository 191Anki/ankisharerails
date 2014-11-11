class Topic < ActiveRecord::Base

  has_many :decks, :dependent => :nullify

  def self.options_for_select
    order('LOWER(name)').map { |e| [e.name, e.id] }
  end

end
