class Pokemon < ApplicationRecord
  belongs_to :type, foreign_key: 'type_id'
  belongs_to :secondary_type, class_name: 'Type', foreign_key: 'secondary_type_id', optional: true
  belongs_to :fake_type, class_name: 'Type', foreign_key: 'fake_type_id', optional: true
  # 他の属性やバリデーション
end

