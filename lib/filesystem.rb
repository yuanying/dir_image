require 'fileutils'

class Filesystem
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

  def initialize path, parent=nil
    @path = Pathname.new(path)
    raise if File.expand_path(real_path).length < Filesystem.config.image_dir.length
    @parent = parent
  end

  attr_accessor :path

  def parent
    unless @parent
      @parent = Directory.new(File.dirname(path))
    end
    @parent
  end

  def real_path
    File.join(Filesystem.config.image_dir, path)
  end

  def tmp_path
    self.path.to_s.split(Filesystem.regexp_path).last
  end

  def name
    File.basename(path)
  end

  def <=>(other)
    self.name <=> other.name
  end

  def ==(other)
    self.path == other.path
  end
end

require 'image'
require 'directory'
