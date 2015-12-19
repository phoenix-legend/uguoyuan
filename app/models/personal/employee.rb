class Personal::Employee < ActiveRecord::Base
  IN_SEVICE = 1
  DIMISSION = 0
  STATUS = [IN_SEVICE, DIMISSION]


  has_and_belongs_to_many :roles, :class_name => '::Personal::Role'
  has_and_belongs_to_many :organizations, :class_name => '::Personal::Organization'


  validates_confirmation_of :password, :message => '两次输入密码不一致'
  validates_presence_of :password, :message => '密码不能为空'
  validates_uniqueness_of :email, :message => 'email 已经存在'
  validates_presence_of :email, :message => 'email 必须填写'
  validates_uniqueness_of :work_number, :message => '工号不能重复', :allow_blank => true
  validates_presence_of :real_name, :message => '姓名必须填写'
  validates_format_of :email, with: EricTools::RegularConstants::EmailRegular, :message => '邮箱格式不正确'
  validate :password_MD5_can_not_be_blank_MD5
  validates :status, inclusion: {in: STATUS}


  def only_one_organization?
    self.organizations.count == 1
  end


  def in_service?
    self.status == 1
  end


  def functions
    roles = self.organizations.collect { |org| org.roles }
    roles << self.roles
    roles = (roles.flatten).uniq

    functions = roles.collect { |role|
      role.functions
    }
    functions = functions.flatten
    roles_functions = functions.uniq
    roles_functions
  end

  def reset_roles role_ids
    ::Personal::Employee.transaction do
      self.roles.clear
      role_ids.each do |id|
        r = ::Personal::Role.find id.to_i
        next if self.roles.exists? r
        self.roles << r
      end
    end
    self
  end

  def password_MD5_can_not_be_blank_MD5
    errors.add(:password, "新密码不能为空") if self.password == Digest::MD5.hexdigest('')
  end

  def modify_password options
    options = ::Personal::Employee.get_arguments_options options, [:old_password, :new_password, :new_password_confirmation]
    BusinessException.raise '密码不正确' if !(self.password == Digest::MD5.hexdigest(options[:old_password]))
    self.password = Digest::MD5.hexdigest(options[:new_password])
    self.password_confirmation = Digest::MD5.hexdigest(options[:new_password_confirmation])
    self.save!
  end

  def update_status
    unless self.teacher.blank?
      if self.status != ::Personal::Employee::IN_SEVICE
        self.teacher.update(:is_valid => false)
      elsif self.status != ::Personal::Employee::IN_SEVICE
        #self.teacher.update( :is_valid => true)
        #todo
        #重新入职暂时不考虑
      end

    end

    unless self.sale.blank?
      if self.status != ::Personal::Employee::IN_SEVICE
        self.sale.update(:is_valid => false)
      elsif self.status != ::Personal::Employee::IN_SEVICE
        #self.teacher.update( :is_valid => true)
        #todo
        #重新入职暂时不考虑
      end

    end
  end


  class << self

    #注册一个会员
    # ::Personal::Employee.create_employee is_teacher:"on", email: "ericliu1002000@163.com", password:"111111", real_name: "ericliu", password_confirmation: "111111"
    # #
    def create_employee(current_employee, options)
      ::Personal::Employee.transaction do
        experience_center_id = current_employee.experience_center_id
        options[:experience_center_id] = experience_center_id
        options[:password] = '111111'
        options[:password_confirmation] = '111111'
        employee = ::Personal::Employee.new options
        employee.status = ::Personal::Employee::IN_SEVICE
        employee.password = Digest::MD5.hexdigest(employee.password)
        employee.password_confirmation = Digest::MD5.hexdigest(employee.password_confirmation)
        employee.save!


        employee.update_status

        employee
      end
    end

    def update_employee(employee_id, options)
      ::Personal::Employee.transaction do
        employee = ::Personal::Employee.find(employee_id)
        if options[:organization_ids].nil?
          options[:organization_ids] = []
        end
        employee.update_attributes! options


        employee.update_status
        employee
      end
    end

    def login email, password
      password = Digest::MD5.hexdigest(password)
      employee = ::Personal::Employee.where(email: email, password: password).first
      BusinessException.raise '用户名和密码不匹配' if employee.blank?
      BusinessException.raise '您已离职' unless employee.status == ::Personal::Employee::IN_SEVICE
      employee
    end

    #Personal::Employee.xx
    def xx
      require 'rest-client'
      (3..100).each do |i|
        sleep 0.2
        pp "car price is: #{i}万"
        url = "https://www.baidu.com/ecomui/finance?controller=Carinsurance&action=aList&city=%E4%B8%8A%E6%B5%B7&carPrice=#{i}&tabValue=&t=1431176589145&serverTime=1431176518857&resourceid=29183&subqid=1431176518853840652&sid=ui%3A0%26bsInsurance%3A4%26bsInvest%3A3%26bsLoan%3A1&category=1105&pssid=11076_1423_12772_13075_10812_12867_11048_13323_13691_10562_12722_13892_13210_13761_13257_13781_11616_13837_8016_13086_8498&tn=baiduhome_pg&zt=ps&pvid=1431176518853840652&qid=10542686875225800426&wd=%E4%BF%9D%E9%99%A9%E6%8A%A5%E4%BB%B7&vSiteSign=3105313369505510982&chengxin=Array&feData=Array&burstFlag=0&curr_sort=1"
        response = RestClient.get url
        a = JSON.parse(response.body)
        a["data"]["list"].each do |data|
          pp "#{data["title"]}: #{data["showPrice"]}"
        end
      end
    end


  end

end