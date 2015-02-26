Heroku buildpack: nginx
=======================

This is a [Heroku buildpack](http://devcenter.heroku.com/articles/buildpack)
for nginx.

Usage
-----

Example usage:

    $ ls -R *
    conf:
    mime.types     nginx.conf.erb

    html:
    index.html

    $ heroku create --stack cedar --buildpack http://github.com/essh/heroku-buildpack-nginx.git
    ...

    $ git push heroku master
    ...
    -----> Heroku receiving push
    -----> Fetching custom buildpack... done
    -----> Nginx app detected
    -----> Fetching nginx binaries
    -----> Vendoring nginx 1.0.11
    ...

The buildpack will detect your app as nginx if it has the file
`nginx.conf.erb` in the `conf` directory. You must define all `listen`
directives as `listen <%= ENV['PORT'] %>;` and also include `daemon off;` in
order for this buildpack to work correctly.

As an alternative to the above instructions you may wish to investigate
[heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi)
in order to support more complex use-cases such as compiling a static site
that is served by nginx or placing nginx in front of app server processes.

Hacking
-------

To modify this buildpack, fork it on Github. Push up changes to your fork, then
create a test app with `--buildpack <your-github-url>` and push to it.

To change the vendored binaries for nginx use the helper script in the
`support/` subdirectory. You may wish to edit the helper script to modify
the nginx build options to suit your needs. You'll need an dropbox-enabled
account to store your binaries in.

Before changing binaries be sure you have run the following (in order to be able to compile nginx):

    $ sudo apt-get install build-essential zlib1g-dev libpcre3 libpcre3-dev unzip

For example, you can change the vendored version of nginx to 1.0.12 and google nginx pagespeed extension to 1.9.32.4 and release to the folder /home/user/nginx_release.

First you'll need to build a Heroku-compatible version of nginx:

    $ support/pagespeed.sh 1.0.12 1.9.32.4 /home/user/nginx_release

The first argument to the package_nginx script is the nginx version. The
second argument is the version of [ngx_pagespeed](https://github.com/pagespeed/ngx_pagespeed) to compile nginx against.

Than you will need to put tgz version of compiled and made nginx with google page speed support to any dropbox folder and share link to this file

Open `bin/compile` in your editor, and change the following lines:

    NGINX_VERSION="1.0.12"
    DOWNLOAD_URL='https://www.dropbox.com/s/hrsbmq3lyagymtd/nginx_ps_1.6.2.tgz?dl=1' #here should be your own dropbox link for built package

Commit and push the changes to your buildpack to your Github fork, then push
your sample app to Heroku to test. You should see:

    -----> Vendoring nginx 1.0.12
