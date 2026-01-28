class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.all.order(:nome)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "Usuário criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy unless @user == Current.user
    redirect_to admin_users_path, notice: "Usuário removido."
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: "Acesso negado." unless Current.user&.admin?
  end

  def user_params
    params.require(:user).permit(:nome, :email, :password, :role)
  end
end