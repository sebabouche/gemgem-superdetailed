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
      Thing.latest.last.id
    end

    def show
      things = Thing.latest
      concept("thing/cell", collection: things, last: things.last)
    end
  end
end
