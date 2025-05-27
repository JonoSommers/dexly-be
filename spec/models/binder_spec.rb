require 'rails_helper'

RSpec.describe Binder, type: :model do
  it { should validate_presence_of(:name) }
end
