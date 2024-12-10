namespace :slurp do
  desc "Load employee data from CSV"
  task employees: :environment do
    require "csv"

    # Read the CSV file from the lib/csvs directory
    csv_text = File.read(Rails.root.join("lib", "csvs", "employees.csv"))
    csv = CSV.parse(csv_text, headers: true, encoding: "ISO-8859-1")

    # Loop through each row in the CSV
    csv.each do |row|
      employee_data = row.to_hash

      # Find or create employee by email
      employee = Employee.find_or_create_by(email: employee_data["email"]) do |emp|
        # Assign the values to employee attributes
        emp.first_name = employee_data["first_name"]
        emp.last_name = employee_data["last_name"]
        emp.title = employee_data["title"]
        emp.organization_id = employee_data["organization_id"]
        emp.password = employee_data["password"]
        emp.image_url = employee_data["image_url"]
      end

      # Update existing employees with the new data (in case of updates)
      employee.update(employee_data.slice("first_name", "last_name", "title", "organization_id", "password", "image_url"))

      puts "Employee #{employee.first_name} #{employee.last_name} saved/updated"
    end

    puts "There are now #{Employee.count} employees in the database."
  end
end

