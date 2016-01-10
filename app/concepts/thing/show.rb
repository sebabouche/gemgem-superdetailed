class Thing < ActiveRecord::Base
  class Show < Trailblazer::Operation
    include Resolver
    model Thing, :find
    policy Thing::Policy, :show?
  end
end
