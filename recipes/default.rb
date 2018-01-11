#
# Cookbook Name:: ffmpeg
# Recipe:: default
#

src_dir = node['ffmpeg']['source_dir']
build_dir = node['ffmpeg']['build_dir']
bin_dir = node['ffmpeg']['bin_dir']

directory src_dir do
  recursive true
end

#
# Dependencies
#

node['ffmpeg']['dependencies'].each do |pkg|
  package pkg
end

#
# yasm
#

yasm_source_path = "#{Chef::Config[:file_cache_path]}/yasm"

%w[yasm yasm-devel].each do |pkg|
  package pkg do
    action :remove
  end
end

install_yasm =
  if ::File.exist?("#{src_dir}/yasm-VERSION.txt")
    node['yasm']['version'] != `cat #{src_dir}/yasm-VERSION.txt`
  else
    true
  end

git 'Download yasm' do
  action :sync
  depth 1
  destination yasm_source_path
  repository 'git://github.com/yasm/yasm.git'
  revision "v#{node['yasm']['version']}"
  only_if { install_yasm }
end

directory yasm_source_path do
  recursive true
  action :nothing
end

execute 'Install yasm' do
  cwd yasm_source_path
  command <<-BASH
    autoreconf -fiv
    ./configure --prefix="#{build_dir}" --bindir="#{bin_dir}"
    make
    make install
    BASH
  only_if { install_yasm }
  notifies :create, "file[#{src_dir}/yasm-VERSION.txt]", :delayed
  notifies :delete, "directory[#{yasm_source_path}]", :delayed
end

file "#{src_dir}/yasm-VERSION.txt" do
  content node['yasm']['version']
  action :nothing
end

#
# Lame
#

# get the major/minor version to install
lame_major_minor = node['lame']['version'].split('.')[0..1].join('.')

lame_tar_tmp_path = "#{Chef::Config[:file_cache_path]}/lame-#{node['lame']['version']}.tar.gz"
lame_source_path = "#{Chef::Config[:file_cache_path]}/lame"

install_lame =
  if ::File.exist?("#{src_dir}/lame-VERSION.txt")
    node['lame']['version'] != `cat #{src_dir}/lame-VERSION.txt`
  else
    true
  end

remote_file 'Download lame' do
  source "http://downloads.sourceforge.net/project/lame/lame/#{lame_major_minor}/lame-#{node['lame']['version']}.tar.gz"
  path lame_tar_tmp_path
  only_if { install_lame }
end

directory lame_source_path do
  recursive true
  only_if { install_lame }
end

execute 'Extract lame' do
  cwd Chef::Config[:file_cache_path]
  command "tar zxf #{lame_tar_tmp_path} -C #{lame_source_path}"
  only_if { install_lame }
end

execute 'Install lame' do
  cwd "#{lame_source_path}/lame-#{node['lame']['version']}"
  command <<-BASH
    ./configure --prefix="#{build_dir}" --bindir="#{bin_dir}" --disable-shared --enable-nasm
    make
    make install
    BASH
  only_if { install_lame }
  notifies :create, "file[#{src_dir}/lame-VERSION.txt]", :delayed
  notifies :delete, 'remote_file[Download lame]', :delayed
  notifies :delete, "directory[#{lame_source_path}]", :delayed
end

file "#{src_dir}/lame-VERSION.txt" do
  content node['lame']['version']
  action :nothing
end

#
# Ogg
#

ogg_tar_tmp_path = "#{Chef::Config[:file_cache_path]}/libogg-#{node['ogg']['version']}.tar.gz"
ogg_source_path = "#{Chef::Config[:file_cache_path]}/ogg"

install_ogg =
  if ::File.exist?("#{src_dir}/ogg-VERSION.txt")
    node['ogg']['version'] != `cat #{src_dir}/ogg-VERSION.txt`
  else
    true
  end

remote_file 'Download ogg' do
  source "http://downloads.xiph.org/releases/ogg/libogg-#{node['ogg']['version']}.tar.gz"
  path ogg_tar_tmp_path
  only_if { install_ogg }
end

directory ogg_source_path do
  recursive true
  only_if { install_ogg }
end

execute 'Extract ogg' do
  cwd Chef::Config[:file_cache_path]
  command "tar zxf #{ogg_tar_tmp_path} -C #{ogg_source_path}"
  only_if { install_ogg }
end

execute 'Install ogg' do
  cwd "#{ogg_source_path}/libogg-#{node['ogg']['version']}"
  command <<-BASH
    ./configure --prefix="#{build_dir}" --disable-shared
    make
    make install
    BASH
  environment(
    'LDFLAGS' => "-L#{build_dir}/lib",
    'CPPFLAGS' => "-I#{build_dir}/include"
  )
  only_if { install_ogg }
  notifies :create, "file[#{src_dir}/ogg-VERSION.txt]", :delayed
  notifies :delete, 'remote_file[Download ogg]', :delayed
  notifies :delete, "directory[#{ogg_source_path}]", :delayed
  notifies :create, "file[#{src_dir}/vorbis-VERSION.txt]", :immediately
end

file "#{src_dir}/ogg-VERSION.txt" do
  content node['ogg']['version']
  action :nothing
end

#
# Vorbis
#

%w[libvorbis libvorbis-devel].each do |pkg|
  package pkg do
    action :remove
  end
end

vorbis_tar_tmp_path = "#{Chef::Config[:file_cache_path]}/libvorbis-#{node['vorbis']['version']}.tar.gz"
vorbis_source_path = "#{Chef::Config[:file_cache_path]}/vorbis"

install_vorbis =
  if ::File.exist?("#{src_dir}/vorbis-VERSION.txt")
    node['vorbis']['version'] != `cat #{src_dir}/vorbis-VERSION.txt`
  else
    true
  end

remote_file 'Download vorbis' do
  source "http://downloads.xiph.org/releases/vorbis/libvorbis-#{node['vorbis']['version']}.tar.gz"
  path vorbis_tar_tmp_path
  only_if { install_vorbis }
end

directory vorbis_source_path do
  recursive true
  only_if { install_vorbis }
end

execute 'Extract vorbis' do
  cwd Chef::Config[:file_cache_path]
  command "tar zxf #{vorbis_tar_tmp_path} -C #{vorbis_source_path}"
  only_if { install_vorbis }
end

execute 'Install vorbis' do
  cwd "#{vorbis_source_path}/libvorbis-#{node['vorbis']['version']}"
  command <<-BASH
    ./configure --prefix="#{build_dir}" --with-ogg="#{build_dir}" --disable-shared
    make
    make install
    BASH
  environment(
    'LDFLAGS' => "-L#{build_dir}/lib",
    'CPPFLAGS' => "-I#{build_dir}/include"
  )
  only_if { install_vorbis }
  notifies :create, "file[#{src_dir}/vorbis-VERSION.txt]", :delayed
  notifies :delete, 'remote_file[Download vorbis]', :delayed
  notifies :delete, "directory[#{vorbis_source_path}]", :delayed
end

file "#{src_dir}/vorbis-VERSION.txt" do
  content node['vorbis']['version']
  action :nothing
end

#
# x264
#

x264_source_path = "#{Chef::Config[:file_cache_path]}/x264"

install_x264 =
  if ::File.exist?("#{src_dir}/x264-VERSION.txt")
    node['x264']['version'] != `cat #{src_dir}/x264-VERSION.txt`
  else
    true
  end

git 'Download x264' do
  depth 1
  destination x264_source_path
  repository node['x264']['repo']
  revision node['x264']['version']
  only_if { install_x264 }
end

directory x264_source_path do
  recursive true
  action :nothing
end

execute 'Install x264' do
  cwd x264_source_path
  command <<-BASH
    export PATH="$PATH:/usr/local/bin"
    ./configure --prefix="#{build_dir}" --bindir="#{bin_dir}" --enable-static
    make
    make install
    BASH
  environment(
    'PKG_CONFIG_PATH' => "#{build_dir}/lib/pkgconfig"
  )
  only_if { install_x264 }
  notifies :create, "file[#{src_dir}/x264-VERSION.txt]", :delayed
  notifies :delete, "directory[#{x264_source_path}]", :delayed
end

file "#{src_dir}/x264-VERSION.txt" do
  content node['x264']['version']
  action :nothing
end

#
# faac
#

faac_tar_tmp_path = "#{Chef::Config[:file_cache_path]}/faac-#{node['faac']['version']}.tar.gz"
faac_source_path = "#{Chef::Config[:file_cache_path]}/faac"

install_faac =
  if ::File.exist?("#{src_dir}/faac-VERSION.txt")
    node['faac']['version'] != `cat #{src_dir}/faac-VERSION.txt`
  else
    true
  end

remote_file 'Download faac' do
  source "http://downloads.sourceforge.net/project/faac/faac-src/faac-#{node['faac']['version']}/faac-#{node['faac']['version']}.tar.gz"
  path faac_tar_tmp_path
  only_if { install_faac }
end

directory faac_source_path do
  recursive true
  only_if { install_faac }
end

execute 'Extract faac' do
  cwd Chef::Config[:file_cache_path]
  command "tar zxf #{faac_tar_tmp_path} -C #{faac_source_path}"
  only_if { install_faac }
end

execute 'Install faac' do
  cwd "#{faac_source_path}/faac-#{node['faac']['version']}"
  command <<-BASH
    ./bootstrap
    ./configure --prefix="#{build_dir}" --bindir="#{bin_dir}" --disable-shared
    # http://stackoverflow.com/a/4320377
    sed -i '126 d' common/mp4v2/mpeg4ip.h
    make
    make install
    BASH
  only_if { install_faac }
  notifies :create, "file[#{src_dir}/faac-VERSION.txt]", :delayed
  notifies :delete, 'remote_file[Download faac]', :delayed
  notifies :delete, "directory[#{faac_source_path}]", :delayed
end

file "#{src_dir}/faac-VERSION.txt" do
  content node['faac']['version']
  action :nothing
end

#
# ffmpeg
#

ffmpeg_tar_tmp_path = "#{Chef::Config[:file_cache_path]}/ffmpeg-#{node['ffmpeg']['version']}.tar.gz"
ffmpeg_source_path = "#{Chef::Config[:file_cache_path]}/ffmpeg"

install_ffmpeg =
  if ::File.exist?("#{src_dir}/ffmpeg-VERSION.txt")
    node['ffmpeg']['version'] != `cat #{src_dir}/ffmpeg-VERSION.txt`
  else
    true
  end

# Only compile ffmpeg if there is a version difference with ffmpeg or any encoder dependencies
run_ffmpeg =
  if install_yasm ||
     install_lame ||
     install_ogg ||
     install_vorbis ||
     install_x264 ||
     install_faac ||
     install_ffmpeg
    true
  else
    false
  end

remote_file 'Download ffmpeg' do
  source "http://ffmpeg.org/releases/ffmpeg-#{node['ffmpeg']['version']}.tar.gz"
  path ffmpeg_tar_tmp_path
  only_if { run_ffmpeg }
end

directory ffmpeg_source_path do
  recursive true
  only_if { run_ffmpeg }
end

execute 'Extract ffmpeg' do
  cwd Chef::Config[:file_cache_path]
  command "tar zxf #{ffmpeg_tar_tmp_path} -C #{ffmpeg_source_path}"
  only_if { run_ffmpeg }
end

execute 'Install ffmpeg' do
  cwd "#{ffmpeg_source_path}/ffmpeg-#{node['ffmpeg']['version']}"
  command <<-BASH
    ./configure --prefix="#{build_dir}" --extra-cflags="-I#{build_dir}/include" --extra-ldflags="-L#{build_dir}/lib" --bindir="#{bin_dir}" --pkg-config-flags="--static" #{node['ffmpeg']['compile_flags'].join(' ')}
    make
    make install
    BASH
  environment(
    'PKG_CONFIG_PATH' => "#{build_dir}/lib/pkgconfig"
  )
  only_if { run_ffmpeg }
  notifies :create, "file[#{src_dir}/ffmpeg-VERSION.txt]", :delayed
  notifies :delete, 'remote_file[Download ffmpeg]', :delayed
  notifies :delete, "directory[#{ffmpeg_source_path}]", :delayed
end

file "#{src_dir}/ffmpeg-VERSION.txt" do
  content node['ffmpeg']['version']
  action :nothing
end
