Cpkg-on-rails
=============

Package manager for VirtLab courses

## Installation

    $ bundle
    $ cp doc/cpkg.rb.example config/initializers/cpkg.rb

 
Edit `config/initializers/cpkg.rb` to configure your installation.

Then

    $ rake db:schema:load

to load che db schema (default with sqlite3 but you can change db
settings in `config/database.yml` file)

To authenticate users the defaut is google omniauth (can change 
with devise configuration file `config/initializers/devise.rb`). 
To create the first administrator use the the 
`cpkg:users:create_admin_user` task:

  $ rake cpkg:users:create_admin_user

At this point you can start the rails server and login.

## Usage


