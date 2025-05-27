require 'rails_helper'

RSpec.describe Card, type: :model do
  it { should validate_presence_of(:id) }
  it { should validate_uniqueness_of(:id) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:set_name) }
  it { should validate_presence_of(:image_url) }
end
