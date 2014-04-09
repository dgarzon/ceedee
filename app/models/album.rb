class Album < ActiveRecord::Base
  belongs_to :user
  has_one :comment
  belongs_to :genre
  has_one :rating
  belongs_to :band
  has_many :tracks

  attr_accessor :query, :genre_query, :rating_query, :comment_query

  def self.create_from_spotify (spotify_id, image_url, user_id, rating_val, comment_val, genre_val)
    response = MetaSpotify::Album.lookup(spotify_id, :extras => 'trackdetail')

    album = Album.create(:spotify_id => spotify_id,
                         :image_url => image_url,
                         :user_id => user_id,
                         :album_name => response.name,
                         :album_id => Album.last.id + 1)

    genre = Genre.where(:genre_name => genre_val).first

    if genre.nil?
      genre = Genre.create(:genre_id => Genre.last.id + 1, :genre_name => genre_val)
      genre.save!
    end

    album.genre_id = genre.id

    rating = Rating.create(:rating_id => Rating.last.id + 1, :rating_value => rating_val, :album_id => album.id)
    rating.save!

    album.rating_id = rating.id

    comment = Comment.create(:comment_id => Comment.last.id + 1, :comment_description => comment_val, :album_id => album.id, :user_id => user_id)
    comment.save!

    album.comment_id = comment.id

    band = Band.where(:band_name => response.artists[0].name).first

    if band.nil?
      band = Band.create(:band_id => Band.last.id + 1, :band_name => response.artists[0].name)
      band.save!
    end

    album.band_id = band.id

    response.tracks.each do |track|
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