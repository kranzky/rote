SemanticLogger.default_level = :trace
SemanticLogger.add_appender(file_name: "log/#{settings.environment}.log", formatter: :color)
SemanticLogger.add_appender(io: $stderr)
helpers do
  def logger
    SemanticLogger['Sinatra']
  end
end
before do
  RequestStore.store[:started] = Time.now
  logger.info "Started #{request.request_method} #{request.path} for #{request.ip}"
end
after do
  RequestStore.store[:completed] = Time.now
  elapsed = ((RequestStore.store[:completed] - RequestStore.store[:started]) * 10000).round / 10.0
  logger.info "Completed #{response.status} #{Rack::Utils::HTTP_STATUS_CODES[response.status]} in #{elapsed}ms" 
end
