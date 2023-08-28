# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pokemon, type: :model do
  it { should belong_to(:type) }
  it { should belong_to(:secondary_type).class_name('Type').optional }
  it { should belong_to(:fake_type).class_name('Type').optional }
end
