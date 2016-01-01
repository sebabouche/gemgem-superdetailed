class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create

    contract Contract::Create
    
    def process(params)
      validate(params[:thing]) do |f|
        f.save
        notify_authors!
        reset_authorships!
      end
    end

    private

    def notify_authors!
      # call a MailerJob or mandrill API
      contract.users.collect do |user|
        if user.created?
          return
          # UserMailer.welcome(user)
        else
          return
          # UserMailer.new_thing(user)
        end
      end
    end

    def reset_authorships!
      model.authorships.each { |au| au.update(confirmed: 0) }
    end
  end
  
  class Update < Create
    action :update

    contract Contract::Update
  end
end
