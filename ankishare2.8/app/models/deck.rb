class Deck < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  validates :author, presence: true
  validates :topic_id, presence: true
  validates :class_name_id, presence: true
  validates :year_id, presence: true
#  validates :notes, presence: true
  validates :professor_id, presence: true

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
  
  belongs_to :topic
  belongs_to :year
  belongs_to :professor
  belongs_to :class_name
 
  scope :with_class_name_id, lambda { |class_name_ids|
    where( :class_name_id => [*class_name_ids])
  }

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

  delegate :topic_name, :to => :topic, :prefix => true
  delegate :year_name, :to => :year, :prefix => true
  delegate :prof_name, :to => :professor, :prefix => true
  delegate :cname, :to => :class_name, :prefix => true

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

  def full_name
    [last_name, first_name].compact.join(', ')
  end

  def decorated_created_at
    created_at.to_date.to_s(:long)
  end

end
