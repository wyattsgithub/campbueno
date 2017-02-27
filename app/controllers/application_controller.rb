class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :ensure_email!

  def ensure_email!
    if current_user && !current_user.email.present?
      redirect_to edit_user_path(current_user.id)
    end
  end
end
