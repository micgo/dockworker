name             'dockworker'
maintainer       'Michael Goetz'
maintainer_email 'mpgoetz@getchef.com'
license          'Apache 2.0'
description      'Installs/Configures dockworker'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'now'
depends 'docker'
depends 'packer'
depends 'build-essential'
depends 'apache2'
depends 'supervisor'