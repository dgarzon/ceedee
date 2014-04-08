class Album < ActiveRecord::Base
  belongs_to :user
  has_one :comment
  belongs_to :genre
  has_one :rating
  belongs_to :band

  attr_accessor :spotify_id
  attr_accessor :query

  def self.create_from_spotify (key)
    spotify = MetaSpotify::Album.lookup(key, :extras => 'trackdetail')
    logger.debug spotify.inspect
  end
end
