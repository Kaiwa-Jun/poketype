# This is the base class for all models in the application.
# frozen_string_literal: true

###
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
