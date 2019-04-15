CarrierWave.configure do |config|
  require 'carrierwave/orm/activerecord'

  config.fog_credentials = {
    provider:                         'Google',
    google_storage_access_key_id:     ENV['GOOGLE_KEY_ID'],
    google_storage_secret_access_key: ENV['GOOGLE_ACCESS_KEY']
  }
  config.fog_directory = 'alert-library-237208'

  if Rails.env.production?
    config.storage :fog
  else
    config.storage :file
  end
end
