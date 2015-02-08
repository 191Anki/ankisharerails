class UploadController < ApplicationController
  def index
     render :file => 'app/views/upload/uploadfile.rhtml'
  end
  def create
    post = DataFile.save(params[:upload])
    render :file => 'app/views/upload/uploadfile.rhtml'
  end
  def show
     send_file params[:type], :x_sendfile => true 
  end
end
