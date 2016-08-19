class Admin::UsersController < ApplicationController
  before_filter :admin_only, except: :end_impersonate
  def index
    @users = User.all.order(params[:sort]).page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save
    redirect_to admin_users_path
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user)
      # else
      #   render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.destroy
        # Tell the UserMailer to send a welcome email after save
        # UserMailer.delete_email(@user).deliver
        format.html { redirect_to admin_users_path, notice: 'User was successfully deleted.' }
        #created creates 201 status for browser
      else
        format.html { redirect_to admin_users_path }
      end
    end
  end

  def impersonate
    session[:admin_user_id] = current_user.id
    session[:user_id] = params[:id]
    redirect_to movies_path
  end

  def end_impersonate
    session[:user_id] = session.delete(:admin_user_id)
    redirect_to movies_path
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end

end