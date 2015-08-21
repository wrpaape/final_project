Rails.application.configure do
  config.cache_classes = true
  config.action_controller.perform_caching = true
  config.action_view.cache_template_loading = true
  config.eager_load = true

  config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.active_record.dump_schema_after_migration = false

  config.log_level = :debug
  config.log_formatter = ::Logger::Formatter.new
end
