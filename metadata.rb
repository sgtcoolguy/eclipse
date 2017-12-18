name             'eclipse'
maintainer       'Chris Williams'
maintainer_email 'cwilliams@axway.com'
license          'Apache-2.0'
description      'Installs/Configures eclipse and plugins'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.1'
issues_url       'https://github.com/appcelerator/eclipse/issues'
source_url       'https://github.com/appcelerator/eclipse'
supports         'ubuntu'
chef_version     '>= 12.19' if respond_to?(:chef_version)

depends          'java'
depends          'ark'
