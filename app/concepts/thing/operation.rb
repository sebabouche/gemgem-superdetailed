class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Thing::Policy, :create?

    include Model
    model Thing, :create

    contract Contract::Create
    
    include Dispatch
    callback :default, Callback::Default
    callback :before_save, Callback::BeforeSave

    def process(params)
      validate(params[:thing]) do |f|
        dispatch!(:before_save)
        f.save
        dispatch!
      end
    end

  end

  class Update < Create
    action :update

    contract Contract::Update
  end
end
