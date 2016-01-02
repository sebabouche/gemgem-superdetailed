module Thing::Callback
  class Default < Disposable::Callback::Group
    collection :users do
      on_add :notify_author!
      on_add :reset_authorship!
    end

    def notify_author!(user, *)
      # commented because mailer doesn't exist
      # return UserMailer.welcome_and_added(user, model) if user.created?
      # UserMailer.thing_added(user, model)
      return
    end

    def reset_authorship!(user, operation:, **)
      user.model.authorships.find_by(thing_id: operation.model.id).update(confirmed: 0)
    end
  end
end
