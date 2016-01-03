class Thing::Cell < Cell::Concept
  property :name
  property :created_at

  def show
    render
  end
  
  include Gemgem::Cell::CreatedAt

  private
  
  def name_link
    link_to name, thing_path(model)
  end
  
  def classes
    classes = ["box", "large-3", "columns"]
    classes << "end" if options[:last] == model
    classes
  end

  class Grid < Cell::Concept
    include Cell::Caching::Notifications
    cache :show do
      # Thing.latest.last.id
      CacheVersion.for("thing/cell/grid")
    end

    def show
      things = Thing.latest
      concept("thing/cell", collection: things, last: things.last)
    end
  end

  class Decorator < Cell::Concept
    extend Paperdragon::Model::Reader
    processable_reader :image
    property :image_meta_data

    def thumb
      image_tag image[:thumb].url if image.exists?
    end
  end
end
