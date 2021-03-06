class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def show
    @booking = Booking.where(user_id: current_user)
  end

  def user_params
    params.require(:user).permit(:provider, :uid, :first_name, :last_name, :email, :profile_url, :oauth_token, :oauth_token_expires_at)
  end

  private
  def set_user
    @user = User.find_by_id(current_user.id) if current_user
    redirect_to root_path, error: 'You have to log in' unless @user
  end
end
