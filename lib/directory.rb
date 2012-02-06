require 'image'

class Directory
  def self.init config
    @config = config
  end

  def self.config
    @config
  end

  attr_accessor :path
  attr_accessor :children
  attr_accessor :images

  def initialize path
    @path = Pathname.new(path)
    raise if File.expand_path(real_path).length < self.class.config.image_dir.length
    @children = []
    @images   = []
    create_index
  end

  def real_path
    File.join(self.class.config.image_dir, path)
  end

  def name
    File.basename(path)
  end

  def create_index
    Dir.foreach(real_path) do |file|
      next if file == '.' || file == '..'
      real_file_path = File.join(real_path, file)
      if File.directory?(real_file_path)
        @children << Directory.new(File.join(path, file))
      elsif File.file?(real_file_path) && Image::SUPPORTED_FORMATS.include?(File.extname(real_file_path))
        @images << Image.new(File.join(path, file), self)
      end
    end
  end

end