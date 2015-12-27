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

  end
end
