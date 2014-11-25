require "connection_pool"

conf = YAML.load(File.read(File.join('config', 'redis.yaml')))
redis_config = conf[Rails.env.to_s]

$redis =  Redis.new host: redis_config['host'], port: redis_config['port'], db: redis_config['db']
