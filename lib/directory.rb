
class Directory < Filesystem

  attr_accessor :path
  attr_accessor :children
  attr_accessor :images

  def initialize path, parent=nil
    super
    @children = []
    @images   = []
    create_index
  end

  def create_index
    Dir.foreach(real_path) do |file|
      next if file.start_with?('.')
      real_file_path = File.join(real_path, file)
      if File.directory?(real_file_path)
        @children << Directory.new(File.join(path, file))
      elsif File.file?(real_file_path) && Image::SUPPORTED_FORMATS.include?(File.extname(real_file_path))
        @images << Image.new(File.join(path, file), self)
      end
    end
    @children.sort!
    @images.sort!
  end

end