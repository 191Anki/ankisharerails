class UploadController < ApplicationController
#def index
# 	render :file => 'app/views/upload/uploadfile.html.erb'
#end
#def uploadFile
#	post = DataFile.save(params[:upload])
#	render :text => "File has been uploaded successfully" 
#end
#def create
#	render :text => params.inspect
	#render :text => "File has been uploaded successfully" 
#end
 def upload
    uploaded_io = params[:file]
    File.open(Rails.root.join('public/data', 'data', uploaded_io.original_filename), 'wb') do |file|
	file.write(uploaded_io.read)
  end
  
#  def download


#    send_file  "#{RAILS_ROOT}/#{params[:file_name]}"
    
#  end

end
end
