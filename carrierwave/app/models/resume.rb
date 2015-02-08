class Resume < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader #Maybe change uploader type later on
  validates :name, presence: true 
  
end
