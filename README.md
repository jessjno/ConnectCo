# ConnectCo
## Description
ConnectCo is a web application that helps employees navigate their organization's structure. It allows employees to identify key contacts, explore departmental roles, and gain insights into the company’s hierarchy, fostering collaboration and efficiency.


## Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Contact-information](#contact-information)

## Features
- Employee Management: Create, read, update, and delete employee profiles.
- Organizational Navigation: Explore organization structures and sub-organizations.
- Responsibility Management: Assign and manage employee responsibilities.
- Advanced Search: Filter employees by name, title, and organization.
- Bulk Import: Upload employees and organizations using CSV files.
- Role-Based Authorization: Secure access control using Pundit.
- Responsive Design: Optimized for desktop, tablet, and mobile devices.

## Installation
1. Clone the repository: Navigate to the project directory:
  `git clone https://github.com/username/connectco.git`
  `cd connectco`

2. Install Dependencies: Run the following command to install all required gems:
   `bundle install`

3. Set Up the Database: Create and migrate the database:
   `rails db:create`
   `rails db:migrate`

4. Run the Application: Start the Rails server:
   `rails server`

## Usage
1. Start the Rails server: rails server

2. Open your browser and navigate to http://localhost:3000 Follow the on-screen instructions to use the application


## Troubleshooting
- **Database errors**: If you run into issues with the database, try running `rails db:reset` and `rails db:migrate` again.
- **Missing gems**: If you encounter errors about missing gems, try running `bundle install` or `bundle update`.
- **Missing dependencies**: If your app fails to start, ensure that all system dependencies (e.g., ImageMagick, Node.js) are installed.

## Contributing

Contributions are welcome! Please follow these guidelines:

1. Fork the repository
2. Create a new branch (`git checkout -b feature-branch`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature-branch`)
5. Open a pull request

## ERD
![Domain Model](https://gist.github.com/user-attachments/assets/7384e66a-b962-4929-8be6-0c2366f841bc) <!--This isn't really working. Try a different approach-->

## License
ConnectCo is licensed under the MIT License. See `LICENSE.md` for more information.

## Contact Information

Jessica JnoBaptiste - [jessjnobaptiste@gmail.com](mailto:jessjnobaptiste@gmail.com)
Project Link: [https://github.com/jessjno/ConnectCo](https://github.com/jessjno/ConnectCo)
