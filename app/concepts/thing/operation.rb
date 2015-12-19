class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    def process(params)
      @model = Thing.create(params[:thing])
    end
  end
end
