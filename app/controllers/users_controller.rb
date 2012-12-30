class UsersController < ApplicationController
  # TODO authentification

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
  end
end
