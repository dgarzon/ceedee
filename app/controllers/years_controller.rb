class YearsController < ApplicationController
  before_action :set_year, only: [:show, :edit, :update, :destroy]
  before_action :load_user

  # GET /years
  # GET /years.json
  def index
    @years = Year.where(:user_id => @user.id).order('year_value ASC')
  end

  # GET /years/1
  # GET /years/1.json
  def show
    @albums = Album.where(:user_id => @user.id, :year_id => params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_year
      @year = Year.find(params[:id])
    end

    def load_user
      if params[:search]
        @user = User.find(params[:search][:user_id])
      else
        @user = User.find(params[:user_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def year_params
      params.require(:year).permit(:year_value, :user_id)
    end
end
