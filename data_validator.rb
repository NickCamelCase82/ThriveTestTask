class DataValidator

  def initialize(users, companies)
    @users = users
    @companies = companies
  end  

  def call
    data_validation
  end

  private

  def data_validation
    @companies.reject! do |company|
      unless company_valid?(company)
        log_error("Invalid company data: #{company.inspect}")
        true
      end
    end

    @users.reject! do |user|
      unless user_valid?(user)
        log_error("Invalid user data: #{user.inspect}")
        true
      end
    end
  end
  
  def company_valid?(company)
    company["name"].is_a?(String) && company["name"] != "" && # For String values we check their type and presence, for Integers we check type as JSON wouldn't allow it not to be present (it should be at least an empty string otherwise Ruby will raise an error). 
    company["top_up"].is_a?(Integer) && # Here lies a potential error if a number with decimal point would be presented. In such case this validator would not validate it and count as an error. To prevent that Integer needs to be replaced with Numeric which allows decimal points.  
    is_boolean?(company["email_status"]) # For Boolean values we're checking if they're boolean, otherwise it does not get validated
  end

  def user_valid?(user)
    user["first_name"].is_a?(String) && user["first_name"] != "" &&
    user["last_name"].is_a?(String) && user["last_name"] != "" &&
    user["email"].is_a?(String) && user["email"] != "" &&
    user["company_id"].is_a?(Integer) && 
    is_boolean?(user["email_status"]) &&
    is_boolean?(user["active_status"]) &&
    user["tokens"].is_a?(Integer)
  end

  def is_boolean?(value)
    value.is_a?(TrueClass) || value.is_a?(FalseClass) # Ruby does not have Boolean class to check for boolean values so we have to use TrueClass and FalseClass for that 
  end

  def log_error(message)
    puts "ERROR: #{message}"
    File.open('error.log', 'a') { |f| f.puts(message) }
  end
end  
