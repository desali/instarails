class LikesController < ApplicationController

	def create
		
	end

	def destroy
		@post_id = params[:like][:post_id]
		Like.where(post_id: @post_id, user_id: current_user.id).first.destroy!
		respond_to do |format|
			format.js {}
		end
	end
end
