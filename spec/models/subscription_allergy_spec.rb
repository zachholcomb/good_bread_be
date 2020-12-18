require 'rails_helper'

RSpec.describe SubscriptionAllergy, type: :model do
  describe "relationships" do
    it { should belong_to(:allergy) }
    it { should belong_to(:subscription) }
  end
end