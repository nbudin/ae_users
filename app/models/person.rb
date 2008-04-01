class Person < ActiveRecord::Base
  establish_connection :users
  has_one :account
  has_many :open_id_identities
  has_and_belongs_to_many :roles
  has_many :permissions, :dependent => :destroy
  has_many :email_addresses, :dependent => :destroy

  def self.sreg_map  
    {:fullname => Proc.new do |fullname|
      if fullname =~ /^([^ ]+) +(.*)$/
        {:firstname => $1, :lastname => $2}
      else
        {:firstname => fullname}
      end
    end, 
    :dob => Proc.new do |dob|
      if dob =~ /^([0-9]{4})-([0-9]{2})-([0-9]{2})$/
        {:birthdate => Time.local($1, $2, $3)}
      else
        {}
      end
    end,
    :gender => Proc.new do |gender|
      if gender == 'M'
        {:gender => 'male'}
      elsif gender == 'F'
        {:gender => 'female'}
      else
        {}
      end
    end,
    :email => Proc.new do |email|
      {:primary_email_address => email}
    end
    }
  end
  
  def self.find_by_email_address(address)
    ea = EmailAddress.find_by_address(address)
    if not ea.nil?
      return ea.person
    end
  end
  
  def primary_email_address
    primary = email_addresses.find_by_primary true
    if not primary
      primary = email_addresses.find :first
    end
    if primary.nil?
      return nil
    else
      return primary.address
    end
  end
  
  def primary_email_address=(address)
    if primary_email_address != address
      ea = email_addresses.find_or_create_by_address(address)
      ea.primary = true
      ea.save
    end
  end

  def all_permissions
    allperms = permissions.find(:all)
    roles.each do |role|
      allperms += role.permissions.find(:all)
    end
    return allperms
  end
  
  def permitted?(obj, perm_name)
    if obj.kind_of? ActiveRecord::Base
      if not obj.id.nil?
        objrep = "#{obj.class.name} #{obj.id}"
      else
        objrep = "Unsaved #{obj.class.name}"
      end
    else
      objrep = obj.to_s
    end
    logger.info "Checking #{name}'s permissions to #{perm_name} on #{objrep}"
    result = false
    all_permissions.each do |permission|
      po = permission.permissioned
      
      if po.kind_of? ActiveRecord::Base
        objmatch = (po.class.name == obj.class.name and po.id == obj.id)
      else
        objmatch = (po == obj)
      end
      
      permmatch = (permission.permission == perm_name)
      
      logger.debug "Permission #{permission.id}: objmatch #{objmatch}, permmatch #{permmatch}"
      result = ((po.nil? or objmatch) and
        (permission.permission.nil? or permmatch))
      
      if result
        logger.debug "Permission match!"
        break
      end
    end
    logger.info "Permission check result: #{result}"
    return result
  end
  
  def administrator_classes
    AeUsers.permissioned_classes.select do |c|
      permitted?(c, "change_permissions_#{c.name.tableize}")
    end
  end
  
  def administrator?
    administrator_classes.length > 0
  end
  
  def current_age
    age_as_of Date.today
  end
  
  def age_as_of(base = Date.today)
    if not birthdate.nil?
      base.year - birthdate.year - ((base.month * 100 + base.day >= birthdate.month * 100 + birthdate.day) ? 0 : 1)
    end
  end
  
  def app_profile
    AeUsers.profile_class.find_by_person_id(id)
  end
  
  def profile
    app_profile
  end
  
  def name
    return "#{firstname} #{lastname}"
#    n = firstname
#    if nickname and nickname.length > 0
#      n += " \"#{nickname}\""
#    end
#    n += " #{lastname}"
#    return n
  end
  
  if not AeUsers.profile_class.nil?
    class_eval <<-END_CODE
    def #{AeUsers.profile_class.name.tableize.singularize}
      app_profile
    end
    END_CODE
  end
end
