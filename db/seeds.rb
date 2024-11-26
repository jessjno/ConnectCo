# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Member.destroy_all

Member.create!([
  { id: 1, role: 'admin' },
  { id: 2, role: 'manager' },
  { id: 3, role: 'employee' },
  { id: 4, role: 'guest' }
])

puts "Seeded #{Member.count} member roles successfully."

admin_organization = Organization.find_or_create_by!(
  name: "Admin Organization",
  description: "Default organization for the admin user."
)

Employee.find_or_create_by!(email: "admin@example.com") do |employee|
  employee.first_name = "Admin"
  employee.last_name = "User"
  employee.title = "System Administrator"
  employee.password = "password123"  
  employee.password_confirmation = "password123"
  employee.organization_id = admin_organization.id
  employee.member_id = 1 
end

puts "Admin user created with email: admin@example.com and password: password123"
