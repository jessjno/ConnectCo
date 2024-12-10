module CsvUploadable
  extend ActiveSupport::Concern

  # This method will handle the CSV file upload logic
  def upload_csv_logic(file, type)
    if file.present?
      begin
        # Array to track failed rows (for better error handling)
        failed_rows = []

        CSV.foreach(file.path, headers: true) do |row|
          begin
            # Parse the row as a hash
            row_data = row.to_hash

            if type == "organization"
              # Handle organization logic here
              organization_data = row_data.slice("id", "name", "description", "parent_id")
              organization = Organization.find_or_create_by(id: organization_data["id"]) do |org|
                org.assign_attributes(organization_data)
              end

              # Check for organization validation errors
              if organization.errors.any?
                Rails.logger.error("Organization creation failed: #{organization.errors.full_messages}")
                failed_rows << { row: row, errors: organization.errors.full_messages }
              else
                organization.save!
              end
            end

            # Handle employee logic here
            if type == "employee"
              employee_data = row_data.slice("first_name", "last_name", "email", "password", "title", "organization_id", "manager_id", "image_url")
              employee = Employee.find_by(email: employee_data["email"]) || Employee.new
              Rails.logger.info("Employee data before assignment: #{employee_data.inspect}")

              # Assign attributes for the employee
              employee.assign_attributes(employee_data)

              Rails.logger.info("Employee after assign_attributes: #{employee.inspect}")

              # Check for employee validation errors
              if employee.errors.any?
                Rails.logger.error("Employee creation failed: #{employee.errors.full_messages}")
                failed_rows << { row: row, errors: employee.errors.full_messages }
              else
                employee.save!
              end
            end

          rescue => e
            Rails.logger.error("Error processing row: #{row}. Error: #{e.message}")
            failed_rows << row
          end
        end

        # Handle the result of the upload (success or failure)
        handle_upload_result(failed_rows, type)

      rescue => e
        Rails.logger.error("Error uploading CSV: #{e.message}")
        redirect_to employees_path, alert: "An error occurred during the CSV upload."
      end
    end
  end

  private

  def handle_upload_result(failed_rows, type)
    if failed_rows.empty?
      # Redirect to the correct path based on the type (employees or organizations)
      if type == "employee"
        redirect_to employees_path, notice: "Employees uploaded successfully."
      elsif type == "organization"
        redirect_to organizations_path, notice: "Organizations uploaded successfully."
      else
        redirect_to root_path, notice: "Upload complete."
      end
    else
      error_message = failed_rows.map { |failed_row| "Row: #{failed_row[:row]} Errors: #{failed_row[:errors].join(', ')}" }.join("\n")
      if type == "employee"
        redirect_to employees_path, alert: "#{failed_rows.count} employees failed to upload:\n#{error_message}"
      elsif type == "organization"
        redirect_to organizations_path, alert: "#{failed_rows.count} organizations failed to upload:\n#{error_message}"
      else
        redirect_to root_path, alert: "Some uploads failed."
      end
    end
  end
end
