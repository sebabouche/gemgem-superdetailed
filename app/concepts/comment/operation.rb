class Comment < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Comment, :create

    def process(params)
      validate(params[:comment]) do |f|
        f.save
      end
    end

    private

    def setup_model!(params)
      model.thing = Thing.find_by_id(params[:thing_id])
    end
  end
end
