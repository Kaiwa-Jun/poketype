# This is the base mailer class that all other mailers inherit from.
# frozen_string_literal: true

###
class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
