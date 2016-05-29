#
# Cookbook Name:: ffmpeg
# Attributes:: default
#
#

default['ffmpeg']['dependencies'] = %w(autoconf automake cmake freetype-devel gcc gcc-c++ git libtool make nasm pkgconfig zlib-devel)

default['ffmpeg']['compile_flags'] = [
  '--enable-nonfree',
  '--enable-gpl',
  '--enable-libx264',
  '--enable-libfaac',
  '--enable-libmp3lame',
  '--enable-libvorbis',
]

default['ffmpeg']['source_dir'] = '/opt/src'
default['ffmpeg']['bin_dir'] = '/usr/local/bin'
default['ffmpeg']['build_dir'] = "#{node['ffmpeg']['source_dir']}/ffmpeg_build"

default['ffmpeg']['version'] = '3.0.2'

default['faac']['version'] = '1.28'

default['lame']['version'] = '3.99.5'

default['ogg']['version'] = '1.3.2'

default['vorbis']['version'] = '1.3.4'

default['x264']['version'] = 'fd2c324731c2199e502ded9eff723d29c6eafe0b'

default['yasm']['version'] = '1.3.0'
