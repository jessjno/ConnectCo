# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Organization.create!([{
  id: 1,
  name: "Admin Org",
  description: "Admin Inc"
}])

Employee.create!([{
    id: 1,
    title: "Admin",
    first_name: "Admin",
    last_name: "Role",
    email: "admin@example.com",
    password: "password",
    admin: true,
    organization_id: 1
  }])
