json.array!(@genres) do |genre|
  json.extract! genre, :id, :genre_name
  json.url genre_url(genre, format: :json)
end
