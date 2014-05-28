class DataFile < ActiveRecord::Base
#  attr_accessor :upload

#  def self.save(upload)
#    name = upload['datafile'].original_filename
#    directory = 'public/data'
    # create the file path
#    path = File.join(directory,name)
    # write the file
#     File.open(path, "wb") { |f| f.write(upload['datafile'].read)}
#  end
   has_attached_file :document,
      :path => ':rails_root/assets/documents/:id/:basename.:extension'
   attr_protected :document_file_name, :document_content_type, :document_file_size
end
