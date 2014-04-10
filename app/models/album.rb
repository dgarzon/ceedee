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

    genre = Genre.where(:genre_name => genre_val, :user_id => user_id).first

    if genre.nil?
      if Genre.last.nil?
        g_id = 1
      else
        g_id = Genre.last.id + 1
      end
      genre = Genre.create(:genre_id => g_id, :genre_name => genre_val, :user_id => user_id)
      genre.save!
    end

    album.genre_id = genre.id

    rating = Rating.create(:rating_id => Rating.last.id + 1, :rating_value => rating_val, :album_id => album.id)
    rating.save!

    album.rating_id = rating.id

    comment = Comment.create(:comment_id => Comment.last.id + 1, :comment_description => comment_val, :album_id => album.id, :user_id => user_id)
    comment.save!

    album.comment_id = comment.id

    year = Year.where(:year_value => response.released, :user_id => user_id).first

    if year.nil?
      if Year.last.nil?
        y_id = 1
      else
        y_id = Year.last.id + 1
      end
      year = Year.create(:year_id => y_id, :year_value => response.released, :user_id => user_id)
      year.save!
    end

    album.year_id = year.id

    band = Band.where(:band_name => response.artists[0].name, :user_id => user_id).first

    if band.nil?
      if Band.last.nil?
        b_id = 1
      else
        b_id = Band.last.id + 1
      end
      band = Band.create(:band_id => b_id, :band_name => response.artists[0].name, :user_id => user_id)
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