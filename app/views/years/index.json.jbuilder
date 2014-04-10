json.array!(@years) do |year|
  json.extract! year, :id, :year_value, :user_id
  json.url year_url(year, format: :json)
end
