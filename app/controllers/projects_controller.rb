class ProjectsController < ApplicationController
  before_action :set_project, only: [:show]

  def index
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project has been created.'
    else
      flash.now[:alert] = 'Project has not been created.'
      render :new
    end
  end

  private

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :description)
    end
end
