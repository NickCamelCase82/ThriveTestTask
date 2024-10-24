require 'json'

class DataProcessor
  def initialize(users_file, companies_file)
    @users = JSON.parse(File.read(users_file))
    @companies = JSON.parse(File.read(companies_file))
    # receives 2 data files in JSON format and parses them
  end

  def call
    clean_up #checks for existing output.txt and error.log and deletes them if exist
    main
  end  

  def main
    require_relative 'data_validator'
    DataValidator.new(@users, @companies).call # Keep entry data validation in separate class which ensures isolation, encapsulation and reusability
    
    companies = @companies.sort_by { |company| company["id"] }  # companies are being sorted by ids in ascending order
    results = []

    companies.each do |company|
      company_users = filtered_users_by_company_id(company["id"])  # This method compares User's company_id with each Company's id and match them, sorting by last name in ascending order
      new_balance_for_users(company, company_users) # This method tops up User's token balances
      results << generate_report(company, company_users) # This method creates a hash with data obtained previously and pushes it to results array
    end

    require_relative 'txt_report_creator'
    TxtReportCreator.new(results).call # Separate class for output.txt report creation. 
  end

  private

  def clean_up
    files = ['output.txt', 'error.log']

    files.each do |file|
      if File.exist?(file)
        File.delete(file)
      end
    end
  end
  
  def filtered_users_by_company_id(company_id)
    @users.select { |user| user["company_id"] == company_id && user["active_status"] }  
          .sort_by { |user| user["last_name"] }
  end

  def new_balance_for_users(company, users)
    users.each do |user|
      next unless company["top_up"]

      previous_balance = user["tokens"]  
      new_balance = previous_balance + company["top_up"].to_i
      user["new_balance"] = new_balance
    end
  end

  def generate_report(company, users)
    emailed_users = []
    non_emailed_users = []
    total_top_up = 0

    users.each do |user|
      if user["email_status"] && company["email_status"] # As per task we only email users whose email_status is true and who belong to companies whose email_status is true, too 
        emailed_users << user
      elsif
        non_emailed_users << user # Otherwise all other users end up in this array
      end

      total_top_up += (user["new_balance"] - user["tokens"]) if user["new_balance"]
    end

    {
      company_id: company["id"],  
      company_name: company["name"],
      emailed_users: emailed_users,
      non_emailed_users: non_emailed_users,
      total_top_up: total_top_up
    }
  end
end

