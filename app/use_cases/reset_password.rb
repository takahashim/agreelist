class ResetPassword
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def reset!
    user.create_reset_digest
    user.send_password_reset_email
  end
end
