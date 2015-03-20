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

  # Makes filters by class name, student year, professor name, creation date, topic, and column sorting 
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

  #For column sorting of decks
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
  
  # Scope for class names
  # For exact matches
  scope :with_class_name_id, lambda { |class_name_ids|
    where( :class_name_id => [*class_name_ids])
  }

  # Searches topic names
  # Finds parts of word, instead of exact matches
  # Descriptions from Filterrific 
  scope :with_topic_id, lambda { |topic_ids|
    #where(:topic_id => [*topic_ids])
    return nil  if topic_ids.blank?
    # condition query, parse into individual keywords
    terms = topic_ids.downcase.split(/\s+/)
    # replace "*" with "%" for wildcard searches,
    # append '%', remove duplicate '%'s
    terms = terms.map { |e|
      (e.gsub('%', '%') + '%').gsub(/%+/, '%')
    }
    # configure number of OR conditions for provision
    # of interpolation arguments. Adjust this if you
    # change the number of OR conditions.
    num_or_conditions = 1
    where(
      terms.map {
        or_clauses = [
          "LOWER(decks.topic_id) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  # Scope for student years
  # For exact matches
   scope :with_year_id, lambda { |year_ids|
     where(:year_id => [*year_ids])
  }

  # Searches topic names
  # Finds parts of word, instead of exact matches
   scope :with_professor_id, lambda { |professor_ids|
     #where(:professor_id => [*professor_ids])
     return nil  if professor_ids.blank?
     terms = professor_ids.downcase.split(/\s+/)
     terms = terms.map { |e|
       (e.gsub('%', '%') + '%').gsub(/%+/, '%')
     }
     num_or_conditions = 1
     where(
       terms.map {
         or_clauses = [
           "LOWER(decks.professor_id) LIKE ?"
         ].join(' OR ')
         "(#{ or_clauses })"
       }.join(' AND '),
       *terms.map { |e| [e] * num_or_conditions }.flatten
     )
  }

  # Searches creation date
  # Finds parts of word, instead of exact matches
  scope :with_created_at_gte, lambda { |ref_date|
    #where('decks.created_at == ?', ref_date)
    return nil  if ref_date.blank?
    terms = ref_date.downcase.split(/\s+/)
    terms = terms.map { |e|
      (e.gsub('%', '%') + '%').gsub(/%+/, '%')
    }
    num_or_conditions = 1
    where(
      terms.map {
        or_clauses = [
          "LOWER(decks.created_at) LIKE ?"
        ].join(' OR ')
        "(#{ or_clauses })"
      }.join(' AND '),
      *terms.map { |e| [e] * num_or_conditions }.flatten
    )
  }

  # For a dropdown selection of sorting
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

  # For displaying creation date. Converts "yyyy-mm-dd" to Month Day, Year
  # ex.) 2015-03-19 -> March 19th, 2015
  def decorated_created_at
    created_at.to_date.to_s(:long)   
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
