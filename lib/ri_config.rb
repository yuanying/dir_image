class RIConfig
  attr_reader :opts
  def initialize path
    @opts = YAML.load_file path
  end

  def image_dir
    File.expand_path(opts['image_dir'])
  end

  def tmp_dir
    File.expand_path(opts['tmp_dir'])
  end

  def db_path
    File.expand_path(opts['db_path']).tap do |db_path|
      FileUtils.mkdir_p(File.dirname(db_path)) unless File.exist?(File.dirname(db_path))
    end
  end
end