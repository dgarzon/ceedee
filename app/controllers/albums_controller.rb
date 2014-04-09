class AlbumsController < ApplicationController
  before_action :set_album, only: [:show, :edit, :update, :destroy]
  before_action :load_user

  # GET /albums
  # GET /albums.json
  def index
    @albums = Album.where(:user_id => @user.id)
  end

  # GET /albums/1
  # GET /albums/1.json
  def show
    logger.debug params
    # @genre = Genre.where(:album_id => params[:album_id]).first
    @comment = Comment.where(:album_id => params[:id]).first
    @rating = Rating.where(:album_id => params[:id]).first
  end

  # GET /albums/new
  def new
    @album = @user.albums.new
  end

  # GET /albums/1/edit
  def edit
  end

  # POST /albums
  # POST /albums.json
  def create
    @album = Album.create_from_spotify(params[:album][:spotify_id], params[:album][:image_url], @user.id, params[:album][:rating_query], params[:album][:comment_query], params[:album][:genre_query])

    respond_to do |format|
      if @album.save
        format.html { redirect_to [@user, @album], notice: 'Album was successfully created.' }
        format.json { render action: 'show', status: :created, location: @album }
      else
        format.html { render action: 'new' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /albums/1
  # PATCH/PUT /albums/1.json
  def update
    respond_to do |format|
      if @album.update(album_params)
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /albums/1
  # DELETE /albums/1.json
  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_album
      @album = Album.find(params[:id])
    end

    def load_user
      if params[:search]
        @user = User.find(params[:search][:user_id])
      else
        @user = User.find(params[:user_id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def album_params
      params.require(:album).permit(:album_name, :user_id, :comment_id, :genre_id, :rating_id, :band_id)
    end
end
