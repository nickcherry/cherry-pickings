def base_url
  URI::HTTP.build(
    Rails.application.config.action_controller.default_url_options
  ).to_s
end
