namespace :slurp do
  desc "Load organization data from CSV"
  task organizations: :environment do
    require "csv"

    # Read the CSV file
    csv_text = File.read(Rails.root.join("lib", "csvs", "organizations.csv"))
    csv = CSV.parse(csv_text, headers: true, encoding: "ISO-8859-1")

    # Loop through each row
    csv.each do |row|
      organization_data = row.to_hash

      # Find or create organization by ID
      organization = Organization.find_or_create_by(id: organization_data["id"]) do |org|
        org.name = organization_data["name"]
        org.description = organization_data["description"]
        org.parent_id = organization_data["parent_id"]
      end

      # Update existing organizations
      organization.update(organization_data.slice("name", "description", "parent_id"))

      puts "Organization #{organization.name} saved/updated"
    end

    puts "There are now #{Organization.count} organizations in the database."
  end
end
