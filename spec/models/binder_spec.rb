require 'rails_helper'

RSpec.describe Binder, type: :model do
  it { should validate_presence_of(:name) }

  it { should have_many(:user_binders).dependent(:destroy) }
  it { should have_many(:users).through(:user_binders) }

  it { should have_many(:binder_cards).dependent(:destroy) }
  it { should have_many(:cards).through(:binder_cards) }
end
