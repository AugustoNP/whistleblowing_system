class PasswordsMailerPreview < ActionMailer::Preview
  def reset
    # Use the first user in your database for the preview
    user = User.first || User.new(username: "testuser", email_address: "test@example.com")
    PasswordsMailer.reset(user)
  end
end
