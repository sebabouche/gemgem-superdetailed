class Thing::Cell < Cell::Concept
  cache :show do
    [model.id, model.updated_at]
  end

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
    def show
      things = Thing.latest
      concept("thing/cell", collection: things, last: things.last)
    end
  end
end
