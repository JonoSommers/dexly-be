require 'rails_helper'

RSpec.describe Card, type: :model do
  subject { create(:card, id: "sv1-1") }

  it { should validate_presence_of(:id) }
  it { should validate_uniqueness_of(:id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:set_name) }
  it { should validate_presence_of(:image_url) }

  it { should have_many(:binder_cards) }
  it { should have_many(:binders).through(:binder_cards) }
end
