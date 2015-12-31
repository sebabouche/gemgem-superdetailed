module Thing::Contract
  class Create < Reform::Form
    model Thing
    
    property :name
    property :description

    validates :name, presence: true
    validates :description, length: {in: 4..160}, allow_blank: true

    collection :users, 
    prepopulator: :prepopulate_users!,
    populate_if_empty: :populate_users!,
    skip_if: :all_blank do

      property :email
      validates :email, presence: true, email: true
      validate :authorship_limit_reached?

      private

      def authorship_limit_reached?
        return if model.authorships.find_all { |au| au.confirmed == 0 }.size < 5
        errors.add("base", "This user has too many unconfirmed authorships.")
      end
    end
    validates :users, length: {maximum: 3}

    private

    def prepopulate_users!(options)
      (3 - users.size).times { users << User.new }
    end

    def populate_users!(fragment:, **)
      User.find_by(email: fragment["email"]) or User.new
    end
  end

  class Update < Create
    property :name, writeable: false

    collection :users, inherit: true, populator: :user! do
      property :remove, virtual: true

      def removeable?
        model.persisted?
      end
    end

    private

    def user!(fragment:, index:, **)
      # don't process if removed
      if fragment["remove"] == "1"
        deserialized_user = users.find { |u| u.id.to_s == fragment[:id] }
        users.delete(deserialized_user)
        return Representable::Pipeline::Stop
      end

      # skip if already existing
      return Representable::Pipeline::Stop if users[:index]

      users.insert(index, User.new)
    end
  end
end
