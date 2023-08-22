class Pokemon < ApplicationRecord
  belongs_to :type, foreign_key: 'type_id'
  belongs_to :fake_type, class_name: 'Type', foreign_key: 'fake_type_id'
end
