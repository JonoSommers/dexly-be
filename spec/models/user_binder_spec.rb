require 'rails_helper'

RSpec.describe UserBinder, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:binder_id) }

  it { should belong_to(:user) }
  it { should belong_to(:binder) }
end
