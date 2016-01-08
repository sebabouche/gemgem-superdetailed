class User < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model User, :create

    contract do
      property :email

      validates :email, presence: true
      validates :email, email: true
    end

    def process(params)
      validate(params[:user]) do
        contract.save
      end
    end
  end
end

