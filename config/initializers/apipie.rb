Apipie.configure do |config|
  config.translate               = false
  config.default_locale          = nil
  config.app_name                = "ToDoApi"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
