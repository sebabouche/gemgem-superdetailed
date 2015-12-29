class Comment::Cell < Cell::Concept
  property :created_at
  property :body
  property :user

  include Gemgem::Cell::GridCell
  self.classes = ["comment", "large-4", "columns"]

  include Gemgem::Cell::CreatedAt

  def show
    render
  end

  private

  def nice?
    model.weight == 0
  end
  
  class Grid < Cell::Concept
    include Kaminari::Cells

    def show
      concept("comment/cell", collection: comments) + paginate(comments)
    end

    private

    def comments
      @comments ||= model.comments.page(page).per(3)
    end

    def page
      options[:page] or 1
    end
  end
end
