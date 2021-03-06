class TicketsController < ApplicationController
  before_action :set_project
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :watch]
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_ticket

  def show
    authorize @ticket, :show?
    @comment = @ticket.comments.build(state_id: @ticket.state_id)
  end

  def new
    @ticket = @project.tickets.build
    authorize @ticket, :create?
    @ticket.attachments.build
  end

  def edit
    authorize @ticket, :update?
  end

  def create
    @ticket = @project.tickets.build

    whitelisted_params = ticket_params
    unless policy(@ticket).tag?
      whitelisted_params.delete(:tag_names)
    end

    @ticket.attributes = whitelisted_params
    @ticket.author = current_user
    authorize @ticket, :create?

    if @ticket.save
      redirect_to [@project, @ticket], notice: 'Ticket has been created.'
    else
      flash.now[:alert] = 'Ticket has not been created.'
      render :new
    end
  end

  def update
    authorize @ticket, :update?

    if @ticket.update(ticket_params)
      redirect_to [@project, @ticket], notice: 'Ticket has been updated.'
    else
      flash.now[:alert] = 'Ticket has not been updated.'
      render :edit
    end
  end

  def destroy
    authorize @ticket, :destroy?

    @ticket.destroy

    redirect_to @project, notice: 'Ticket has been deleted.'
  end

  def search
    authorize @project, :show?
    if params[:search].present?
      @tickets = @project.tickets.search(params[:search])
    else
      @tickets = @project.tickets
    end
    render 'projects/show'
  end

  def watch
    authorize @ticket, :show?
    if @ticket.watchers.exists?(current_user.id)
      @ticket.watchers.destroy(current_user)
      flash[:notice] = 'You are no longer watching this ticket.'
    else
      @ticket.watchers << current_user
      flash[:notice] = "You are now watching this ticket."
    end
    redirect_to project_ticket_path(@ticket.project, @ticket)
  end

  private

    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_ticket
      @ticket = @project.tickets.find(params[:id])
    end

    def invalid_ticket
      logger.error "Attempt to access invalid ticket -> #{params[:id]}"
      redirect_to @project,
        alert: 'The ticket you were looking for could not be found.'
    end

    def ticket_params
      params.require(:ticket).permit(:name, :description, :tag_names,
        attachments_attributes: [:file, :file_cache])
    end
end
