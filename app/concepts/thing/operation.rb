class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create

    contract Contract::Create
    
    def process(params)
      validate(params[:thing]) do |f|
        f.save
        reset_authorships!
        notify_authors!
      end
    end

    private

    def reset_authorships!
      model.authorships.each { |au| au.update(confirmed: 0) }
    end

    def notify_authors!
      # call a MailerJob or mandrill API
      # model.users.collect do |user|
      #  UserMailer.welcome_email(user)
      # end
    end
  end
  
  class Update < Create
    action :update

    contract Contract::Update
  end
end
