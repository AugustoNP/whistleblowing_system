module Admin
  class UsersController < BaseController # Inherits ensure_admin! check
    def index
      @users = User.order(:username)
      @new_user = User.new
    end

    def create
      @new_user = User.new(user_params)
      if @new_user.save
        redirect_to admin_users_path, notice: "Usuário criado."
      else

        @users = User.where.not(role: :visitor)

        render :index, status: :unprocessable_entity
      end
    end

    def update
      @user = User.find(params[:id])
      
      # Prevent self-demotion
      if @user == Current.user && params[:user][:role] != "admin"
        return redirect_to admin_users_path, alert: "Você não pode remover seu próprio acesso Admin.", status: :see_other
      end

      if @user.update(params.require(:user).permit(:role, :username, :email_address))
          # Turbo will see this redirect and only update the "admin_users_list" frame
          redirect_to admin_users_path, notice: "Dados atualizados.", status: :see_other
      else
          @users = User.where.not(role: :visitor)
          render :index, status: :unprocessable_entity
      end
    end

def update_password
  @user = User.find(params[:id])
  if @user.update(params.require(:user).permit(:password, :password_confirmation))
    @user.sessions.destroy_all 
    # Added status: :see_other to prevent page reset
    redirect_to admin_users_path, notice: "Senha alterada.", status: :see_other
  else
    # Better to render index so we can show the specific error
    @users = User.order(:username)
    @new_user = User.new
    render :index, status: :unprocessable_entity
  end
end

def destroy
  @user = User.find(params[:id])
  unless @user == Current.user
    @user.destroy
    redirect_to admin_users_path, notice: "Conta removida.", status: :see_other
  else
    redirect_to admin_users_path, alert: "Não é possível excluir a própria conta.", status: :see_other
  end
end

    private

    def user_params
      params.require(:user).permit(:username, :email_address, :role, :password, :password_confirmation)
    end
  end
end