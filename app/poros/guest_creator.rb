class GuestCreator
  class << self
    def create(params)
      GuestCreator.new(params).set_guest
    end
  end

  attr_reader :email,
              :name,
              :address,
              :zip,
              :city,
              :state,
              :role

  def initialize(params)
    @email = params[:email]
    @name = params[:name]
    @address = params[:address]
    @zip = params[:zip]
    @city = params[:city]
    @state = params[:state]
    @role = 0
  end

  def set_guest
    User.create(
      email: email,
      name: name,
      address: address,
      city: city,
      state: state,
      zip: zip,
      role: role,
      password: set_default_password,
      password_confirmation: set_default_password
    )
  end

  private

  def set_default_password
    'default'
  end
end
