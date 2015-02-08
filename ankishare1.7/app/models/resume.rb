require 'csv'
require 'rubygems'
require 'zip'

class Resume < ActiveRecord::Base
#Attachment uploader  
  mount_uploader :attachment, AttachmentUploader #Maybe change uploader type later on
#Validation
  validates :name, presence: true 
  validates :subject, presence: true
#  validates :class, presence: true 
#  validates :front, presence: true
#Anki Deck Properties 
  belongs_to :category
  belongs_to :user
#Categories  
#  validates :category, presence: true
#Zip
  folder = ""
  
    
end
