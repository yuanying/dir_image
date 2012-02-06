require 'fileutils'
require 'image_science'

class Image

  SUPPORTED_FORMATS = ['.png', '.PNG', '.jpg', '.JPG', '.jpeg']

  def self.init config
    @config = config
  end

  def self.config
    @config
  end

  def self.tmp_dir
    self.config.tmp_dir
  end

  def self.regexp_path
    unless @regexp_path
      @regexp_path = Regexp.compile('^' + Regexp.escape(self.config.image_dir))
    end
    @regexp_path
  end

  def initialize path, parent = nil
    @path   = Pathname.new(path)
    raise if File.expand_path(real_path).length < self.class.config.image_dir.length
    @parent = parent
  end

  attr_accessor :path

  def parent
    require 'directory'
    unless @parent
      @parent = Directory.new(File.dirname(path))
    end
    @parent
  end

  def real_path
    File.join(self.class.config.image_dir, path)
  end

  def tmp_path
    self.path.to_s.split(self.class.regexp_path).last
  end

  def create_thumbnail thumbnail_path
    ImageScience.with_image(self.real_path) do |img|
      img.cropped_thumbnail(76) do |thumb|
        thumb.save thumbnail_path
      end
    end
  # rescue
  #   puts "Cannot create thumbnail: #{path}"
  end

  def thumbnail_path
    File.join(self.class.tmp_dir, 'thumb', tmp_path).tap do |thumbnail_path|
      FileUtils.mkdir_p(File.dirname(thumbnail_path)) unless File.exist?(File.dirname(thumbnail_path))
      self.create_thumbnail(thumbnail_path)           unless File.exist?(thumbnail_path)
    end
  end

end

