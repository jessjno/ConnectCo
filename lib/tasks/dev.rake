desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do

# Destroy previous data
if Rails.env.development?
  Organization.destroy_all
  Employee.destroy_all
  Member.destroy_all
  Responsibility.destroy_all
end

  # Generating Memberships
  pp "Generating Memberships"

  CSV.foreach('lib/sample_data/members.csv', :headers => true) do |row|
    member = Member.new
    member.id = row.fetch("id")
    member.role = row.fetch("role")
    member.save
  end

  pp "There are now #{Member.count} memberships."

  # Generating Organization
  pp "Generating Organizations"

  CSV.foreach('lib/sample_data/organizations.csv', :headers => true) do |row|
    organization = Organization.new
    organization.id = row.fetch("id")
    organization.name = row.fetch("name")
    organization.description = row.fetch("description")
    organization.parent_id = row.fetch("parent_id")
    organization.save
  end

  pp "There are now #{Organization.count} organizations."

   # Generating Employees
   pp "Generating Employees"

   CSV.foreach('lib/sample_data/employees.csv', :headers => true) do |row|
     employee = Employee.new
     employee.id = row.fetch("id")
     employee.first_name = row.fetch("first_name")
     employee.last_name = row.fetch("last_name")
     employee.email = row.fetch("email")
     employee.password = row.fetch("password")
     employee.title = row.fetch("title")
     employee.member_id = row.fetch("member_id")
     employee.organization_id = row.fetch("organization_id")
     employee.save
   end
 
   pp "There are now #{Employee.count} employees."

    # Generating Responsibilities
    pp "Generating Responsibilities"

    CSV.foreach('lib/sample_data/responsibillites.csv', :headers => true) do |row|
      responsibility = Responsibility.new
      responsibility.id = row.fetch("id")
      responsibility.name = row.fetch("name")
      responsibility.description = row.fetch("description")
      responsibility.organization_id = row.fetch("organization_id")
      responsibility.employee_id = row.fetch("employee_id")
      responsibility.save
    end
  
    pp "There are now #{Responsibility.count} responsibilities."
end
