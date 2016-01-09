class ThingsController < ApplicationController
  respond_to :html

  def new
    form Thing::Create

    render_form
  end

  def create
    run Thing::Create do |op|
      return redirect_to op.model
    end

    render_form
  end

  def edit
    form Thing::Update

    render_form
  end

  def update
    run Thing::Update do |op|
      return redirect_to op.model
    end

    render_form
  end

  def show
    @thing_op = present Thing::Update
    @thing = @thing_op.model

    form Comment::Create
  end

  def create_comment
    @thing_op = present Thing::Update
    @thing = @thing_op.model

    run Comment::Create, params: params.merge(thing_id: params[:id]) do |op|
      flash[:notice] = "Created comment for \"#{op.thing.name}\""
      return redirect_to thing_path(op.thing)
    end

    render :show
  end

  def next_comments
    present Thing::Update

    render js: concept("comment/cell/grid", @model, page: params[:page]).(:append)
  end

  private

  def render_form
    render text: concept("thing/cell/form", @operation), layout: true
  end

end
