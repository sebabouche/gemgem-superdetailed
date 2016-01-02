class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create

    callback do
      collection :users do
        on_add :notify_author!
        on_add :reset_authorship!
      end
    end

    contract Contract::Create
    
    def process(params)
      validate(params[:thing]) do |f|
        f.save
        dispatch!
      end
    end

    private

    def notify_author!(user, options)
      # commented because mailer doesn't exist
      # return UserMailer.welcome_and_added(user, model) if user.created?
      # UserMailer.thing_added(user, model)
    end

    def reset_authorship!(user, options)
      user.model.authorships.find_by(thing_id: model.id).update(confirmed: 0)
    end
  end
  
  class Update < Create
    action :update

    contract Contract::Update
  end
end
