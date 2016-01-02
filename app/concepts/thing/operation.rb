class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create

    callback do
      collection :users do
        on_add :notify_authors!
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
      contract.users.each do |user|
        next unless contract.users.added.include?(user)
        model.authorships.each { |au| au.update(confirmed: 0) }
      end
    end
  end
  
  class Update < Create
    action :update

    contract Contract::Update
  end
end
