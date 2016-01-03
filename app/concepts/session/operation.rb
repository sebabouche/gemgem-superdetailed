module Session
  class SignUp < Trailblazer::Operation
    include Model
    model User, :create

    contract do
      property :email
      property :password, virtual: true
      property :confirm_password, virtual: true

      validates :email, :password, :confirm_password, presence: true
      validate :password_ok?

      private

      def password_ok?
        return unless email and password
        return if password == confirm_password
        errors.add("password", "Password don't match")
      end
    end

    def process(params)
      validate(params[:user]) do
        create!
        contract.save
      end
    end

    def create!
      auth = Tyrant::Authenticatable.new(contract.model)
      auth.digest!(contract.password)
      auth.confirmed!
      auth.sync
    end
  end
end


