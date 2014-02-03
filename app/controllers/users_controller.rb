class UsersController < ApplicationController
  before_action :signed_in_user, 
            only: [:index, :edit, :update, :destroy, :show, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def show
  	@user= User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  def new
    if !signed_in?
  	   @user = User.new
    else
      redirect_to root_url
    end
  end

  def create
    if signed_in?
      redirect_to root_url
    else
  	   @user= User.new(user_params)
  	   if @user.save
          sign_in @user
          flash[:success]= "Welcome to the Sample App!"
  		    redirect_to @user
  	   else
  		    render 'new'
  	   end
    end
  end

  def following
    @title= "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers 
    @title= "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def index
    @users= User.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success]= "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
     if !current_user?(@user)
        @user.destroy
        flash[:success]= "User deleted."
        redirect_to users_url
      else
        flash[:error]= "Cannot delete yourself"
        render "users"
      end
  end

  private

  def user_params
  	params.require(:user).permit(:name, :email, :password, 
                                :password_confirmation)
  end

  #before filters

  def correct_user
    @user= User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
