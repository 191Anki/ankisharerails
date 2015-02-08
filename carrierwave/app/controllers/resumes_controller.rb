class ResumesController < ApplicationController
  def index
    @resumes = Resume.all
  end

  def new
    @resume = Resume.new
  end

  def create
    @resume = Resume.new(upload_params)
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
  end

  private
    def upload_params
      params.require(:resume).permit( :name, :attachment)
    end
end
