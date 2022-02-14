resque_config = YAML.load_file(Rails.root.join('config', 'resque.yml'))
Resque.redis = resque_config['redis']["#{Rails.env}"]
