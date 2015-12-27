class CommentsController < ApplicationController
  def new
    @thing = Thing.find(params[:thing_id])

    form Comment::Create
  end

  def create
    run Comment::Create do |op|
      return redirect_to thing_path(op.model.thing)
    end
    render action: :new
  end
end

