# Ninety Nine Cats

Ninety Nine Cats is a web application, allowing users to rent their cats to others. Based on App Academy Open course project, with some add ons.

Live version: [Ninety Nine Cats](https://immense-atoll-53088.herokuapp.com/)


### Features:
- setting up and editing account
- sending invitation emails
- logging in with session
- adding cats with images
- sending requests for renting other users' cats
- approving or denying requests for user's own cats

### Technologies:

- Ruby 2.7.2,
- Rails 5.2.4,
- Bulma CSS framework
- PostgreSQL

### Integrations
* Cloudinary for Active Storage
* Gmail for Action Mailer

### Setup

To run locally, you have to have Ruby in version 2.7.2  installed on your machine.
Next you have to execute 
```
.bin/setup
```
 which is script that will install bundler,
create and seed database. Then you have to run 
```
bundle exec rails server
```
 and the app will be available at __localhost:3000__ in your browser.

