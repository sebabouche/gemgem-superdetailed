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
        errors.add("password", "Passwords don't match")
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
  
  class SignIn < Trailblazer::Operation
    contract do
      undef :persisted? # TODO: allow with trailblazer/reform.
      attr_reader :user

      property :email, virtual: true
      property :password, virtual: true
      validates :email, :password, presence: true
      validate :password_ok?


      private

      def password_ok?
        return if email.blank? or password.blank?
        @user = User.find_by(email: email)
        errors.add("Passord", "Wrong password.") unless @user and Tyrant::Authenticatable.new(@user).digest?(password)
      end
    end

    def process(params)
      validate(params[:session]) do |contract|
        @model = contract.user
      end
    end
  end

  class SignOut < Trailblazer::Operation
    def process(params)
    end
  end
end


