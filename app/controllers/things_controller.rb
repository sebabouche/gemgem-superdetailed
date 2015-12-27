class ThingsController < ApplicationController
  respond_to :html

  def new
    form Thing::Create
  end

  def create
    run Thing::Create do |op|
      return redirect_to op.model
    end

    render action: :new
  end

  def edit
    form Thing::Update

    render action: :new
  end

  def update
    run Thing::Update do |op|
      return redirect_to op.model
    end

    render action: :edit
  end

  def show
    @thing_op = present Thing::Update
    @thing = @thing_op.model

    form Comment::Create
  end

end
