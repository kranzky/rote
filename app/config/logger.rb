SemanticLogger.default_level = :trace
SemanticLogger.add_appender(file_name: "log/#{settings.environment}.log", formatter: :color)
SemanticLogger.add_appender(io: $stderr)
helpers do
  def logger
    SemanticLogger['RotE']
  end
end
before do
  Thread.current[:rote][:started] = Time.now
  logger.info "Started #{request.request_method} #{request.path} for #{request.ip}"
end
after do
  Thread.current[:rote][:completed] = Time.now
  elapsed = ((Thread.current[:rote][:completed] - Thread.current[:rote][:started]) * 10000).round / 10.0
  logger.info "Completed #{response.status} #{Rack::Utils::HTTP_STATUS_CODES[response.status]} in #{elapsed}ms" 
end
