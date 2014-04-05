class HomeController < ApplicationController
  before_action :load_user, only: [:index]

  def index
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end
end
