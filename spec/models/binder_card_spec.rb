require 'rails_helper'

RSpec.describe BinderCard, type: :model do
  it { should validate_presence_of(:binder_id) }
  it { should validate_presence_of(:card_id) }

  it { should belong_to(:binder) }
  it { should belong_to(:card) }
end
