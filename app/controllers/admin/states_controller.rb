class Admin::StatesController < Admin::ApplicationController
  def index
    @states = State.all
  end

  def new
    @state = State.new
  end

  def create
    @state = State.new(state_params)
    if @state.save
      redirect_to admin_states_path, notice: "State has been created."
    else
      flash.now[:alert] = "State has not been created."
      render :new
    end
  end

  def make_default
    @state = State.find(params[:id])
    @state.make_default!

    flash[:notice] = "'#{@state.name}' is now the default state."
    redirect_to admin_states_url
  end

  private

    def state_params
      params.require(:state).permit(:name, :color)
    end
end
