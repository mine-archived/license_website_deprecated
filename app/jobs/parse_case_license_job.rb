class ParseCaseLicenseJob < ActiveJob::Base
  # queue_as :urgent
  queue_as :default

  def perform(*args)
    # Do something later
    puts args
  end

  after_perform do |job|
    # TODO: rails generate mailer UserMailer
    # If you want to send the email now use #deliver_now
    # UserMailer.welcome(@user).deliver_now
  end

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do something with the exception
  end
end
