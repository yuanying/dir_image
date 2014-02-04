require 'rack'
require 'fileutils'

class Filesystem
  def self.init config
    @config = config
  end

  def self.config
    @config
  end

  def self.directory? index, path
    File.directory?(self.real_path(index, path))
  end

  def self.real_path index, path
    File.join(Filesystem.image_dir(index), path)
  end

  def self.tmp_dir
    self.config.tmp_dir
  end

  def self.image_dir index
    File.expand_path(Filesystem.config.image_dirs[index])
  end

  def initialize index, path, parent=nil
    @path   = path
    @index  = index.to_i
    raise if File.expand_path(real_path).length < Filesystem.image_dir(index).length
    @parent = parent if parent
  end

  attr_accessor :path
  attr_accessor :index

  def parent
    unless defined?(@parent)
      @parent = Directory.get(index, File.dirname(path))
    end
    @parent
  end

  def real_path
    Filesystem.real_path(index, path)
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
