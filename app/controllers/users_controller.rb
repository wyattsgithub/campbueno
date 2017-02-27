class UsersController < ApplicationController
  skip_before_action :ensure_email!, only: [:edit, :update]

  def edit
    @user = User.where(id: current_user.id).first
  end

  def update
    @user = User.where(id: current_user.id).first
    @user.assign_attributes(user_params)

    if @user.save
      redirect_to root_path
    else
      render action: :edit
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :cell_phone, :email, :address)
  end
end