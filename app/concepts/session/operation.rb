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
        return if contract.password == contract.confirm_password
        errors.add("password", "Password don't match")
      end
    end
  end
end


