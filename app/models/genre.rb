class Genre < ActiveRecord::Base
  has_many :albums
  belongs_to :user
end
