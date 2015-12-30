class Thing < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model
    model Thing, :create

    contract do
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

    def process(params)
      validate(params[:thing]) do |f|
        f.save
        reset_authorships!
      end
    end

    private

    def reset_authorships!
      model.authorships.each { |au| au.update(confirmed: 0) }
    end
  end
  
  class Update < Create
    action :update

    contract do
      property :name, writeable: false

      collection :users, inherit: true do
        property :remove, virtual: true

        def removeable?
          model.persisted?
        end
      end
    end
  end
end
