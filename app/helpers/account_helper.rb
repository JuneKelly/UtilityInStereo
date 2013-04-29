module AccountHelper

  def check_admin(user)
    if user.account_type == "admin" && user.is_admin && user.is_active
      return true
    else
      return false
    end
  end

end