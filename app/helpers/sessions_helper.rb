module SessionsHelper

  # Saves user_id in session
  def sign_in(user)
    session[:user_id] = user.id
  end

  def signed_in?
    !current_user.nil?
  end

<<<<<<< HEAD
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        sign_in user
        @current_user = user
      end
    end
  end
=======
	def current_user?(user_id)
		user_id == current_user.id if current_user
	end

	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end
>>>>>>> 06a881721f546ffdc46aa6405168085f646c98ec

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Remembers a user in a persistent session.
 def remember(user)
   user.remember
   cookies.permanent.signed[:user_id] = user.id
   cookies.permanent[:remember_token] = user.remember_token
 end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def sign_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
