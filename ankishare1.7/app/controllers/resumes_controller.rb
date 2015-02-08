
class ResumesController < ApplicationController
 # before_action :set_user, only: [ :create, :destroy]
  load_and_authorize_resource
  skip_authorize_resource 

  def index
    @resumes = Resume.all
  end

  def new
    @resume = Resume.new
  end

  def create
    @resume = Resume.new(resume_params)
    if @resume.save
	redirect_to resumes_path, notice: "#{@resume.name} has been uploaded."
    else
      render "new"
    end
  end
  
  def destroy
    @resume = Resume.find(params[ :id])
    @resume.destroy
    redirect_to resumes_path, notice: "#{@resume.name} has been deleted."
    authorize! :destroy, @resume
  end

    def resume_params
      params.require(:resume).permit(:name, :subject, :attachment)
    end
  
end
