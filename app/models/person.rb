class Person < ActiveRecord::Base
  acts_as_ae_users_shared_model
  has_one :account
  has_many :open_id_identities
  has_and_belongs_to_many :roles
  has_many :permissions, :dependent => :destroy, :include => :permissioned
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
    allperms = permissions
    roles.each do |role|
      allperms += role.permissions
    end
    return allperms
  end
  
  def permitted?(obj, perm_name)
    if AeUsers.cache_permissions?
      if obj and obj.kind_of? ActiveRecord::Base
        return AeUsers.permission_cache.permitted?(self, obj, perm_name)
      else
        return AeUsers.permission_cache.permitted?(self, nil, perm_name)
      end
    else
      return uncached_permitted?(obj, perm_name)
    end
  end
  
  def uncached_permitted?(obj, perm_name)
    result = false
    all_permissions.each do |permission|
      po = permission.permissioned
      
      if po.kind_of? ActiveRecord::Base
        objmatch = (po.class.name == obj.class.name and po.id == obj.id)
      else
        objmatch = (po == obj)
      end
      
      permmatch = (permission.permission == perm_name)
      
      result = ((po.nil? or objmatch) and
        (permission.permission.nil? or permmatch))
      
      if result
        break
      end
    end
    logger.debug "Permission check result: #{result}"
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
    @app_profile ||= AeUsers.profile_class.find_by_person_id(id)
    @app_profile
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
