
class Directory < Filesystem

  def self.get index, path, parent=nil
    @cache ||= {}
    index = index.to_i
    real_path = Filesystem.real_path(index, path)
    unless directory = @cache[real_path]
      directory = Directory.new(index, path, parent)
    end
    directory
  end

  def initialize index, path, parent=nil
    super
  end

  def url
    "/dirs/#{index}?path=#{Rack::Utils.escape(path)}"
  end

  def thumb_url
    "/thumbs/#{index}?path=#{Rack::Utils.escape(path)}"
  end

  def children
    create_index
    @children
  end

  def images
    create_index
    @images
  end

  def create_thumbnail
  end

  def thumbnail_path
    create_index
    if @images.size > 0
      @images[0].thumbnail_path
    else
      File.join(File.dirname(__FILE__), '..', 'public', 'images', 'dir.png')
    end
  end

  def create_index
    unless defined?(@children) && defined?(@images)
      @children = []
      @images   = []
      Dir.foreach(real_path) do |file|
        next if file.start_with?('.')
        real_file_path = File.join(real_path, file)
        if File.directory?(real_file_path)
          @children << Directory.get(index, File.join(path, file))
        elsif File.file?(real_file_path) && Image::SUPPORTED_FORMATS.include?(File.extname(real_file_path))
          @images << Image.get(index, File.join(path, file), self)
        end
      end
      @children.sort!
      @images.sort!
    end
  end

end