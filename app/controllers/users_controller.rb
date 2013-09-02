class UsersController < ApplicationController
	before_action :require_current_user,    only: [:index, :edit, :update]
	before_action :require_correct_user,		only: [:edit, :update]
  before_action :admin_user,     					only: :destroy
  
	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def show
    @user = User.find(params[:id])
	end

	def create
		@user = User.new(user_params)
		if @user.save
			# session[:user_id] = @user.user_id
			flash[:success] = "Welcome to Frog, #{@user.first_name.capitalize} #{@user.last_name.capitalize}!"			
			redirect_to @user
		else
			render action: :new
		end
	end

	def edit
		@user = User.find(params[:id])
	end

  def update
  	@user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Your profile was updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user_to_delete = User.find(params[:id])
    # if !current_user?(@user_to_delete)
      @user_to_delete.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    # else
    #   redirect_to root_url
    # end
  end

	private

		def user_params
			params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
		end

		def admin_user
      redirect_to(root_url) unless set_current_user.admin?
    end

end
