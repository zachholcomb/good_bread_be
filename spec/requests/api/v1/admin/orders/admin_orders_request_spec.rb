require 'rails_helper'

RSpec.describe 'Admin orders request spec' do
  before(:each) do
    @admin = User.create(
      email: "admin@example.com",
      name: "Admin Name",
      address: "445 West St.",
      password: '1234',
      role: 2
    )

    @user1 = User.create!(
      email: 'john@example.com',
      name: 'John Wick',
      address: '900 Victoria St.',
      password: '1234',
      password_confirmation: '1234'
    )
  end
end