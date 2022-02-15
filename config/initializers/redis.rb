require 'redis'

uri = URI.parse('redis:6379')
REDIS = Redis.new(host: uri.host, port: uri.port)
