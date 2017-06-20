class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_project

  def index
    @projects = Project.all
  end

  def show
    authorize @project, :show?
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project has been updated.'
    else
      flash.now[:alert] = 'Project has not been updated.'
      render :edit
    end
  end

  private

    def set_project
      @project = Project.find(params[:id])
    end

    def invalid_project
      logger.error "Attempt to access invalid project -> #{params[:id]}"
      redirect_to projects_url,
        alert: 'The project you were looking for could not be found.'
    end

    def project_params
      params.require(:project).permit(:name, :description)
    end
end
