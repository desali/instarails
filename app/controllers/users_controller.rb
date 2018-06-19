class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def show
		@user = User.find(params[:id])
	end

	def new
		@user = User.new
	end

	def create
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			redirect_to @user
		else
			render :new
		end
	end

	def edit
	end

	def update
	 # @user = User.find(params[:id])
	 # if @user.update_attributes(user_params)
		#  redirect_to @user, :notice => "User updated."
	 # else
		#  redirect_to @user, :alert => "Unable to update user."
	 # end
	end

	def destroy
		# user = User.find(params[:id])
    # user.destroy
    # redirect_to @user, :notice => "User deleted."
	end

	private

	def user_params
		params.require(:user).permit(:username, :email, :password, :avatar)
	end

end
