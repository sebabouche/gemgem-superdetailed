module Thing::Callback
  class Default < Disposable::Callback::Group
    collection :users do
      on_add :notify_author!
      on_add :reset_authorship!
    end

    on_change :expire_cache!

    def notify_author!(user, *)
      # commented because mailer doesn't exist
      # return UserMailer.welcome_and_added(user, model) if user.created?
      # UserMailer.thing_added(user, model)
      return
    end

    def reset_authorship!(user, operation:, **)
      user.model.authorships.find_by(thing_id: operation.model.id).update(confirmed: 0)
    end

    def expire_cache!(thing, *)
      CacheVersion.for("thing/cell/grid").expire!
    end
  end

  class BeforeSave < Disposable::Callback::Group
    on_change :upload_image!, property: :file

    collection :users do
      on_add :sign_up_sleeping!
    end

    def upload_image!(thing, operation:, **)
      operation.contract.image!(operation.contract.file) do |v|
        v.process!(:original)
        v.process!(:thumb) { |job| job.thumb!("120x120#") }
      end
    end

    def sign_up_sleeping!(user, **)
      return if user.persisted?
      auth = Tyrant::Authenticatable.new(user.model)
      auth.confirmable!
      auth.sync
    end
  end
end
