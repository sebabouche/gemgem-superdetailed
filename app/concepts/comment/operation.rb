class Comment < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Comment, :create

    contract do
      property :body
      property :weight
      property :thing

      validates :body, length: { in: 6..160 }
      validates :weight, inclusion: { in: ["0", "1"] }
      validates :thing, :user, presence: true

      property :user, prepopulator: ->(*) { self.user = User.new } do
        property :email
        validates :email, presence: true, email: true
      end
    end

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
