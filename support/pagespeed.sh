cd
if [ "$1" == "" ]; then
  NGINX_VERSION=1.6.2
else 
  NGINX_VERSION=$1
fi

if [ "$2" == "" ]; then
  NPS_VERSION=1.9.32.3
else
  NPS_VERSION=$2
fi

if ["$3" == "" ]; then
RELEASE_FOLDER=/tmp
else
RELEASE_FOLDER=$3
fi

echo "Building nginx v.$NGINX_VERSION with google nginx pagespeed module v.$NPS_VERSION"

wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip
unzip release-${NPS_VERSION}-beta.zip
cd ngx_pagespeed-release-${NPS_VERSION}-beta/
wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz
tar -xzvf ${NPS_VERSION}.tar.gz
cd
# check http://nginx.org/en/download.html for the latest version
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
./configure --prefix=${RELEASE_FOLDER} --add-module=$HOME/ngx_pagespeed-release-${NPS_VERSION}-beta
make
make install
cd ${RELEASE_FOLDER}
tar -czvf nginx_ps_${NGINX_VERSION}.tgz *
cd
echo "Please find your build version at $RELEASE_FOLDER called: nginx_ps_$NGINX_VERSION.tgz"