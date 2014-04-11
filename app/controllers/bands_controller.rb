class BandsController < ApplicationController
  before_action :set_band, only: [:show, :edit, :update, :destroy]
  before_action :load_user

  # GET /bands
  # GET /bands.json
  def index
    @bands = Band.where(:user_id => @user.id).order('band_name ASC')
  end

  # GET /bands/1
  # GET /bands/1.json
  def show
    @albums = Album.where(:user_id => @user.id, :band_id => params[:id])

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_band
      @band = Band.find(params[:id])
    end

    def load_user
      if params[:search]
        @user = User.find(params[:search][:user_id])
      else
        @user = User.find(params[:user_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def band_params
      params.require(:band).permit(:band_name, :user_id)
    end
end
