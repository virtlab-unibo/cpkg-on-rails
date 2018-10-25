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

```bash
    $ cd cpkg-on-rails
    $ bundle
    $ cp doc/dm_unibo_common.yml config/dm_unibo_common.yaml
    $ cp doc/cpkg.rb.example config/initializers/cpkg.rb
```

Edit `config/dm_unibo_common.yaml` and `config/initializers/cpkg.rb` 
to configure your installation. 

In `config/database.yml` configure database and username and set the database password
in your environment as CPKG_DATABASE_PASSWORD.

Generate a new secret_key_base with `rake secret` and put it in your environment as 
SECRET_KEY_BASE.

Then set the cpkg directory in CPKG_ROOT.

For example your `$HOME/.bashrc` can have 

```bash
export CPKG_SECRET_KEY_BASE=28ee1481f4376882211efcac2abb2473cc6af6baf86b54ca54605b99bf0109250c7d6c771b9ee1fdfc9aa6442342ab6ab1343dd845a2a5bc8287ec40e5186e36
export CPKG_DATABASE_PASSWORD=veryveryverysecret
export CPKG_BASEDIR=/home/rails/cpkg-on-rails
```

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

## GPG

Create new keys to sign packages: RSA and RSA (default) with 4096 bits. For example: Real name: Virtlab Unibo Cpkg, Email address: ****@****, Comment: Package manager for VirtLab courses

    $ gpg --full-gen-key 

and get the sign with 

    $ gpg --list-secret-keys

Copy  the `gpg key-id` as config.gpg_key = "09A0DEDE" in `config/initializers/cpkg.rb`

To export the key 

    $ gpg --output public.key --armor --export 

and to import the key in virtual machine

    $ cat public.key | apt-key add -


## Getting started

Enter as admin and

*  Insert at least one repository to fetch .deb packages. Remember to
   update it after you have inserted.
*  Create at least a Degree (A degree is a set of Courses)
*  Create at least a Course (A course is a set of Packages)

Now you can start creating packages, uploading to a local debian repository or
download them directly from cpkg.
