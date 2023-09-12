# This is the model for the pokemon table in the database
# frozen_string_literal: true

###
class Pokemon < ApplicationRecord
  belongs_to :type, foreign_key: 'type_id'
  belongs_to :secondary_type, class_name: 'Type', foreign_key: 'secondary_type_id', optional: true
  belongs_to :fake_type, class_name: 'Type', foreign_key: 'fake_type_id', optional: true

  validates :type, presence: true # type_idが存在するタイプと関連していることを確認
  validates :secondary_type, presence: true, if: -> { secondary_type_id.present? } # secondary_type_idが存在する場合、関連するタイプが存在することを確認
  validates :fake_type, presence: true, if: -> { fake_type_id.present? } # fake_type_idが存在する場合、関連するタイプが存在することを確認
end
