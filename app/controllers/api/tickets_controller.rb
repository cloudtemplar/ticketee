class API::TicketsController < API::ApplicationController
  before_action :set_project

  def show
    @ticket = @project.tickets.find(params[:id])
    authorize @ticket, :show?
    render json: @ticket
  end

  def create
    @ticket = @project.tickets.build(ticket_params)
    authorize @ticket, :create?
    if @ticket.save
      render json: @ticket, status: 201
    else
      render json: { errors: @ticket.errors.full_messages }, status: 422
    end
  end

  def update
    @ticket = @project.tickets.find(params[:id])
    authorize @ticket, :update?

    if @ticket.update(ticket_params)
      head :no_content
    else
      render json: { errors: @ticket.errors.full_messages }, status: 422
    end
  end

  def destroy
    @ticket = @project.tickets.find(params[:id])
    authorize @ticket, :destroy?
    @ticket.destroy
    head :no_content
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def ticket_params
      params.require(:ticket).permit(:name, :description)
    end
end
