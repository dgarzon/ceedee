json.array!(@albums) do |album|
  json.extract! album, :id, :album_name, :user_id, :comment_id, :genre_id, :rating_id, :band_id
  json.url album_url(album, format: :json)
end
