class Comment::Cell < Cell::Concept
  property :created_at
  property :body
  property :user

  def show
    render
  end
end
