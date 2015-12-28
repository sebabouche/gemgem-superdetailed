class Comment::Cell < Cell::Concept
  property :created_at
  property :body
  property :user

  include Gemgem::Cell::GridCell
  self.classes = ["comment", "large-4", "columns"]

  def show
    render
  end
end
