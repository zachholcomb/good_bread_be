class LoginHandler
  class << self
    def session(payload)
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      session.login
    end
  end
end