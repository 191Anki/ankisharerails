class Deck < ActiveRecord::Base
  # Deck model
  # Contains filterrific gem methods
  mount_uploader :attachment, AttachmentUploader
  # Validates whether there is a value in the upload form field for 
  # each of the following database fields
  validates :author, presence: true
  validates :topic_id, presence: true
  validates :class_name_id, presence: true
  validates :year_id, presence: true
#  validates :notes, presence: true
  validates :professor_id, presence: true

  # 
  filterrific :default_settings => { :sorted_by => 'created_at_desc' },
              :filter_names => %w[
                sorted_by
                with_class_name_id
                with_topic_id
                with_professor_id
                with_year_id
                with_created_at_gte
              ]

  # default for will_paginate
  self.per_page = 10
  
  # Topic, Year, Professor, Class_name all have a Deck
  # Deck has many Cards
  belongs_to :topic
  belongs_to :year
  belongs_to :professor
  belongs_to :class_name
  belongs_to :user
  #belongs_to :card
  has_many :card

  # Connects database fields from Deck with database fields from
  # Topic, Year, Professor, and Class_Name
  delegate :topic_name, :to => :topic, :prefix => true
  delegate :year_name, :to => :year, :prefix => true
  delegate :prof_name, :to => :professor, :prefix => true
  delegate :cname, :to => :class_name, :prefix => true
  delegate :student_year, :to => :s_year, :prefix => true 

  scope :sorted_by, lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
    when /^created_at_/
      order("decks.created_at #{ direction }")
    when /^year_/
      order("LOWER(decks.year_id) #{ direction }").includes( :year)
    when /^topic_name_/
      order("LOWER(decks.topic_id) #{ direction }").includes( :topic)
    when /^class_name_/
      order("LOWER(decks.class_name_id) #{ direction }").includes( :class_name)
    when /^professor_name_/
      order("LOWER(decks.professor_id) #{ direction }").includes( :professor)
    else
      raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }
  
  # Scope: takes in all :class_name
  scope :with_class_name_id, lambda { |class_name_ids|
    where( :class_name_id => [*class_name_ids])
  }

  scope :with_topic_id, lambda { |topic_ids|
    where(:topic_id => [*topic_ids])
  }

   scope :with_year_id, lambda { |year_ids|
     where(:year_id => [*year_ids])
  }

   scope :with_professor_id, lambda { |professor_ids|
     where(:professor_id => [*professor_ids])
  }

  scope :with_created_at_gte, lambda { |ref_date|
    where('decks.created_at >= ?', ref_date)
  }

  def self.options_for_sorted_by
    [
      ['Student Years(1-4)', 'year_name_asc'],
      ['Student Years(4-1)', 'year_name_desc'],
      ['Registration date (newest first)', 'created_at_desc'],
      ['Registration date (oldest first)', 'created_at_asc'],
      ['Topics (a-z)', 'topic_name_asc'],
      ['Topics (z-a)', 'topic_name_desc'],
      ['Professors (a-z)', 'prof_name_asc'],
      ['Professors (z-a)', 'prof_name_desc'],
      ['Class Name (a-z)', 'cname_asc'],
      ['Class Name (z-a)', 'cname_desc']
    ]
  end
  #http://guides.rubyonrails.org/layouts_and_rendering.html  
  #Try render to different pages, may not work though since has to connect with controller 
  # More viable option may be to use javascript
  def self.options_for_sorted_by_1
     #@user = User.find(current_user)
     #if :year_id == '2'
      [
        ['Anatomy & Embryology', 'Anatomy & Embryology'],
        ['Neurosciences', 'Neurosciences'],
        ['Histology', 'Histology']
      ]
     #else
     # [
     #   ['Anatomy & Embryology', 'Anatomy & Embryology'],
     #   ['Neurosciences', 'Neurosciences'],
     #   ['Mistology', 'Histology']
     # ]
    #end
  end

  def full_name
    [last_name, first_name].compact.join(', ')
  end

  def decorated_created_at
    created_at.to_date.to_s(:long)
  end

  def increment(attribute, by = 1)
    self[attribute] ||= 0
    self[attribute] += by
    self
  end

  def increment!(attribute, by = 1)
    increment(attribute, by).update_attribute(attribute, self[attribute])
  end
  
end
