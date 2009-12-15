class PersonSession < Authlogic::Session::Base
  attr_accessor :email, :password, :return_to, :have_password
  
  validate :validate_illyan_account, :if => :authenticating_with_illyan_account?
  
  def credentials
    if authenticating_with_illyan_account?
      details = {}
      details[:email] = email
      details[:password] = '<protected>'
      details[:have_password] = have_password
      details
    else
      super
    end
  end
  
  def credentials=(value)
    super
    values = value.is_a?(Array) ? value : [value]
    hash = values.first.is_a?(Hash) ? values.first.with_indifferent_access : nil
    if !hash.nil?
      self.email = hash[:email] if hash.key?(:email)
      self.password = hash[:password] if hash.key?(:password)
      self.have_password = hash[:have_password] if hash.key?(:have_password)
    end
  end
  
  private
  def authenticating_with_illyan_account?
    !email.blank? || have_password
  end
  
  def validate_illyan_account
    errors.add(:email, I18n.t('error_messages.email_blank', :default => 'cannot be blank')) if email.blank?
    errors.add(:password, I18n.t('error_messages.password_blank', :default => 'cannot be blank')) if password.blank?
    errors.add(:have_password, I18n.t('error_messages.have_password_false', :default => 'must be true')) unless have_password
    return if errors.count > 0
    
    account = Account.find_by_email_address(email)
    if account and account.check_password(password)
      errors.add(:account, I18n.t('error_messages.account_inactive', :default => 'is not active')) unless account.active?
      errors.add(:account, I18n.t('error_messages.no_person'), :default => 'has no associated person record') if account.person.nil?
      return if errors.count > 0
      
      self.attempted_record = person
    end
  end
end
