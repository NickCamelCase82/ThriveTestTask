class TxtReportCreator

  def initialize(results)
    @data = results
  end  

  def call
    create_report
  end  

  private
  
  def create_report # Pretty muich basic and straightforward method that creates an output.txt file as per requirements
    File.open('output.txt', "w") do |file|
      @data.each do |company|
        file.puts "Company Id: #{company[:company_id]}"
        file.puts "\tCompany Name: #{company[:company_name]}"
        file.puts "\tUsers Emailed:"
        company[:emailed_users].each do |user|
          file.puts "\t\t#{user['last_name']}, #{user['first_name']}, #{user['email']}"
          file.puts "\t\t  Previous Token Balance, #{user['tokens']}"  
          file.puts "\t\t  New Token Balance #{user['new_balance']}"
        end
        file.puts "\tUsers Not Emailed:"
        company[:non_emailed_users].each do |user|
          file.puts "\t\t#{user['last_name']}, #{user['first_name']}, #{user['email']}"
          file.puts "\t\t  Previous Token Balance, #{user['tokens']}"  
          file.puts "\t\t  New Token Balance #{user['new_balance']}"
        end
        file.puts "\t\tTotal amount of top ups for #{company[:company_name]}: #{company[:total_top_up]}"
        file.puts "\n"
      end
    end   
  end  
end  
