class AdminHubController < ApplicationController
  before_action :require_admin!

  def index
    @users = User.where.not(id: Current.user.id).order(:username)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_hub_index_path, notice: "Usuário #{@user.username} atualizado."
    else
      @users = User.all
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_hub_index_path, notice: "Usuário removido do sistema."
  end

  private

  def require_admin!
    # The highest level of permission
    redirect_to root_path, alert: "Acesso restrito ao Administrador." unless Current.user&.admin?
  end

  def user_params
    # Only permit role changes and basic info
    params.require(:user).permit(:role, :email_address, :username)
  end
end