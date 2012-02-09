require 'image_science'

class Image < Filesystem

  SUPPORTED_FORMATS = ['.png', '.PNG', '.jpg', '.JPG', '.jpeg']

  def self.get index, path, parent=nil
    @cache ||= {}
    index = index.to_i
    real_path = Filesystem.real_path(index,path)
    unless image = @cache[real_path]
      image = Image.new(index, path, parent)
    end
    image
  end

  def initialize index, path, parent = nil
    super
  end

  def url
    "/files/#{index}?path=#{path}"
  end

  def page_url
    "/images/#{index}?path=#{path}"
  end

  def thumb_url
    "/thumbs/#{index}?path=#{path}"
  end

  def next
    unless defined?(@next)
      @next = parent.images[parent.images.index(self) + 1]
    end
    @next
  end

  def previous
    unless defined?(@previous)
      index = parent.images.index(self) - 1
      if index < 0
        @previous = nil
      else
        @previous = parent.images[index]
      end
    end
    @previous
  end

  def create_thumbnail
    return if File.exist?(thumbnail_path)

    FileUtils.mkdir_p(File.dirname(thumbnail_path)) unless File.exist?(File.dirname(thumbnail_path))

    ImageScience.with_image(self.real_path) do |img|
      img.cropped_thumbnail(76) do |thumb|
        thumb.save thumbnail_path
      end
    end
  rescue
    puts "Cannot create thumbnail: #{path}"
  end

  def thumbnail_path
    File.join(Filesystem.tmp_dir, 'thumb', real_path)
  end

end

