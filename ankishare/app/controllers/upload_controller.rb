class UploadController < ApplicationController
 
  def upload
    uploaded_io = params[:file]
    File.open(Rails.root.join('public/data', 'data', uploaded_io.original_filename), 'wb') do |file|
	file.write(uploaded_io.read)
  end
end
end

