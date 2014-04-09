class Album < ActiveRecord::Base
  belongs_to :user
  has_one :comment
  belongs_to :genre
  has_one :rating
  belongs_to :band
  has_many :tracks

  attr_accessor :query, :genre_query, :rating_query, :comment_query

  def self.create_from_spotify (spotify_id, image_url, user_id)

    response = MetaSpotify::Album.lookup(spotify_id, :extras => 'trackdetail')

    album = Album.create(:spotify_id => spotify_id,
                         :image_url => image_url,
                         :genre_id => 1,
                         :user_id => user_id,
                         :album_name => response.name,
                         :album_id => Album.last.id + 1)

    album.save!

    if !album.persisted?
      redirect_to :back, alert: "Something went wrong, please try again."
    end

    band = Band.where(:band_name => response.artists[0].name)

    if band.nil? || band.empty?
      logger.debug "Band not found.. Proceed to create!"
      band = Band.create(:band_id => Band.last.id + 1, :band_name => response.artists[0].name)
      band.save!
    end

    logger.debug band.inspect

    album.band_id = band.id

    response.tracks.each do |track|
      logger.debug track.name
      logger.debug track.track_number
      logger.debug track.length
      song = Track.create(:track_id => Track.last.id + 1,
                          :album_id => album.id,
                          :track_name => track.name,
                          :track_duration => track.length,
                          :track_number => track.track_number)

      song.save!
    end

    album

  end
end