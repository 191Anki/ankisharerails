class Card < ActiveRecord::Base
  # Card model 
  belongs_to :deck
  #has_many :deck

  # For CKEditor, updates individual card database values
  delegate :id, :to => :deck_id, :prefix => true
	def update_card(front, back)
  	front = front.gsub! "\r", ""
  	front = front.gsub! "\n", ""
  	back = back.gsub! "\r", ""
  	back = back.gsub! "\n", ""
		self.card_front = front
		self.card_back  = back
  	save
  end

  # For incrementing deck database values
  def increment(attribute, by = 1)
    self[attribute] ||= 0
    self[attribute] += by
    self
  end

  # For incrementing deck database values
  def increment!(attribute, by = 1)
    increment(attribute, by).update_attribute(attribute, self[attribute])
  end

end
