module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_account

    def connect
      self.current_account = find_verified_account
    end

    private

    def find_verified_account
      if verified_account && cookies.signed['account_expires_at'] > Time.current
        verified_account
      else
        reject_unauthorized_connection
      end
    end

    def verified_account
      @verified_account ||= Account.find_by(id: cookies.signed[:account_id])
    end
  end
end
