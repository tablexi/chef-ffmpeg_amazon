name 'ffmpeg_amazon'
maintainer 'Table XI'
maintainer_email 'sysadmins@tablexi.com'
license 'MIT'
description 'Installs/Configures FFMPEG'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version_file = File.join(File.dirname(__FILE__), 'VERSION')
version File.exist?(version_file) ? IO.read(version_file) : '0.0.0'

supports 'amazon'

depends 'git'
