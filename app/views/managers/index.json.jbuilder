json.array!(@managers) do |manager|
  json.extract! manager, :id, :provider, :uid, :name, :email, :oauth_token, :oauth_expires_at
  json.url manager_url(manager, format: :json)
end
