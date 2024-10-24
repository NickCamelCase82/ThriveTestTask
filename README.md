Data Processor

This Ruby script processes user and company data from JSON files, performs token top-ups for users, validates data integrity, and generates a detailed report. The report highlights users who received top-ups, their previous and new balances, and users who were emailed or not emailed based on the company’s email status.

Features:

Data Validation: Ensures companies and users meet certain criteria before processing.
Token Top-Up Calculation: Adds the specified token top-up amount to users associated with companies.
Report Generation: Creates a report in output.txt showing detailed token changes per user and company.
Error Logging: Invalid data entries are being deleted from data input and logged into error.log for further processing.
File Cleanup: Automatically deletes old output.txt and error.log files before generating new ones.

Requirements:

Ruby 2.5 or later

Gems:
json (for parsing JSON files)

Installation:
Clone the Repository:

$ git clone https://github.com/NickCamelCase82/ThriveTestTask.git
$ bundle install

Provide Input Files:
Prepare two JSON files: one for users and one for companies. Place them in the project directory or provide paths to these files when running the script.

Usage:
To run the script and generate the token top-up report you need

1. in terminal run "rails c" to enter Rails console
2. type load "path/challenge.rb" where "path" is your path to challenge.rb file
3. type DataProcessor.new("users.json", "companies.json").call ("users.json" and "companies.json" can be replaced with whatever names of data files in JSON format and
   don't forget to specify the path if they're not in the same directory with challenge.rb file)

Input Data Format:
Each User entry JSON file should include:

{
"id": 1,
"company_id": 101,
"first_name": "John",
"last_name": "Doe",
"email": "john.doe@example.com",
"tokens": 50,
"active_status": true,
"email_status": true
}

Each Companies entry JSON file should include:

{
"id": 101,
"name": "Example Corp",
"top_up": 25,
"email_status": true
}

Report Output:

The script generates a report in output.txt detailing

1. Users who received top-ups, with their new token balances.
2. Whether the user was emailed based on their and the company's email statuses.
3. A summary of token top-ups per company.

Error Logging:

Any invalid data entries are being deleted from data file and logged to error.log with details about the validation failurefor further processing.

File Cleanup:
Before each run, the script checks for existing output.txt and error.log files and deletes them to ensure fresh results.

Known Limitations
The script assumes that the input JSON files are properly formatted. If there's a syntax error, the script will fail.
Error handling for missing or malformed fields could be extended further.
