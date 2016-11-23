Cpkg-on-rails
=============

Package manager for VirtLab courses.
This web app is able to create .deb metapackages or documentation packages.

## Requirements

Only debian or ubuntu server are supported. Although you can successfully
install it on other linux distros as long as you install dpkg and the debhelper utilities. This is because by default it use active_debian_repository gem. You can easily port that gem to rpm or other formats and then use cpkg with it.


*  Rails 5
*  Ruby 2.3+
*  debhelper

## Languages 

*  Italian
*  English

## Installation

Clone the repository and 

    $ cd cpkg-on-rails
    $ bundle
    $ cp doc/dm_unibo_common.yml config/dm_unibo_common.yaml
    $ cp doc/cpkg.rb.example config/initializers/cpkg.rb

Edit `config/dm_unibo_common.yaml` and `config/initializers/cpkg.rb` 
to configure your installation. 

In `config/initializers/cpkg.rb` manually change `config.secret_key_base` with a random key. 
You can generate a new key with `rake secret` (for example `sed -i -e "s/'SECRET KEY BASE.*'/'$(rake secret)'/" cpkg.rb`).

You should also change almost all the other preferences according to your setup.

   Then

    $ rake db:schema:load

to load che db schema (default with sqlite3 but you can change db
settings in `config/database.yml` file)

To authenticate users the defaut is google_oauth2 omniauth 
(can change with shibboleth or other omniauth strategies, see 
[https://github.com/intridea/omniauth/wiki/List-of-Strategies]) 
in `config/dm_unibo_common.yaml`.

To create the first administrator use the `cpkg:users:create_admin_user` task:

    $ rake cpkg:users:create_admin_user

At this point you can start the rails server and login with your 
google creadentials as administrator.

## Getting started

Enter as admin and

*  Insert at least one repository to fetch .deb packages. Remember to
   update it after you have inserted.
*  Create at least a Degree (A degree is a set of Courses)
*  Create at least a Course (A course is a set of Packages)

Now you can start creating packages, uploading to a local debian repository or
download them directly from cpkg.
