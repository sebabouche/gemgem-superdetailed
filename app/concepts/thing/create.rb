class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Resolver
    policy Thing::Policy, :create?
    model Thing, :create

    builds -> (model, policy, params) do
      return self::Admin if policy.admin?
      return self::SignedIn if policy.signed_in?
    end

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

    class SignedIn < self
      include Thing::SignedIn
    end

    class Admin < SignedIn
    end

  end
end
