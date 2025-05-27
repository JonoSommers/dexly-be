require 'rails_helper'

RSpec.describe UserBinder, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:binder_id) }
end
