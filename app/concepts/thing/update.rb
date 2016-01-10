class Thing < ActiveRecord::Base
  class Update < Create
    self.builder_class = Create.builder_class
    policy Thing::Policy, :update?
    action :update

    contract Contract::Update

    class SignedIn < self
      contract do
        property :name, writable: false
      end
    end

    class Admin < SignedIn
      include Thing::SignedIn

      contract do
        property :name
      end
    end
  end
end
