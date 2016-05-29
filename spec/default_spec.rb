require 'spec_helper'

describe 'ffmpeg_amazon::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new.converge(described_recipe) }

  it 'create /opt/source directory' do
    expect(chef_run).to create_directory('/opt/source')
  end

  it 'install dependencies' do
    chef_run.node['ffmpeg']['dependencies'].each do |pkg|
      expect(chef_run).to install_package pkg
    end
  end

  describe 'yasm' do
    it 'remove package if installed' do
      %w(yasm yasm-devel).each do |pkg|
        expect(chef_run).to remove_package pkg
      end
    end

    it 'download yasm' do
      expect(chef_run).to sync_git 'Download yasm'
    end

    it 'install yasm' do
      expect(chef_run).to run_execute 'Install yasm'
    end

    it 'delete git directory' do
      resource = chef_run.directory('yasm')
      expect(resource).to do_nothing

      resource = chef_run.execute('Install yasm')
      expect(resource).to notify('directory[yasm]')
    end

    it 'create version file' do
      expect(chef_run).to create_file("#{node['ffmpeg']['source_dir']}/yasm-VERSION.txt")
    end
  end

  describe 'Lame' do
    it 'create lame-VERSION.txt file' do
      expect(chef_run).to create_file('/opt/source/lame-VERSION.txt')
    end

    it 'download tarball' do
      resource = chef_run.remote_file('Download Lame')
      expect(resource).to do_nothing

      resource = chef_run.file('/opt/source/lame-VERSION.txt')
      expect(resource).to notify('remote_file[Download Lame]')
    end

    it 'extract' do
      resource = chef_run.tarball('Extract Lame')
      expect(resource).to do_nothing

      resource = chef_run.remote_file('Download Lame')
      expect(resource).to notify('tarball[Extract Lame]')
    end

    it 'execute' do
      resource = chef_run.execute('Install Lame')
      expect(resource).to do_nothing

      resource = chef_run.tarball('Extract Lame')
      expect(resource).to notify('execute[Install Lame]')
    end
  end

  describe 'Vorbis' do
    it 'install packages' do
      %w(libvorbis libvorbis-devel).each do |pkg|
        expect(chef_run).to install_package(pkg)
      end
    end
  end

  it 'include x264::source recipe' do
    expect(chef_run).to include_recipe('x264::source')
  end

  describe 'faac' do
    it 'create faac-VERSION.txt file' do
      expect(chef_run).to create_file('/opt/source/faac-VERSION.txt')
    end

    it 'download tarball' do
      resource = chef_run.remote_file('Download faac')
      expect(resource).to do_nothing

      resource = chef_run.file('/opt/source/faac-VERSION.txt')
      expect(resource).to notify('remote_file[Download faac]')
    end

    it 'extract' do
      resource = chef_run.tarball('Extract faac')
      expect(resource).to do_nothing

      resource = chef_run.remote_file('Download faac')
      expect(resource).to notify('tarball[Extract faac]')
    end

    it 'execute' do
      resource = chef_run.execute('Install faac')
      expect(resource).to do_nothing

      resource = chef_run.tarball('Extract faac')
      expect(resource).to notify('execute[Install faac]')
    end
  end

  describe 'ldconfig' do
    it 'create /etc/ld.so.conf.d/local_lib.conf' do
      expect(chef_run).to create_file('/etc/ld.so.conf.d/local_lib.conf')
    end

    it 'execute ldconfig' do
      resource = chef_run.execute('ldconfig')
      expect(resource).to do_nothing

      resource = chef_run.file('/etc/ld.so.conf.d/local_lib.conf')
      expect(resource).to notify('execute[ldconfig]')
    end
  end

  describe 'ffmpeg' do
    it 'create ffmpeg-VERSION.txt file' do
      expect(chef_run).to create_file('/opt/source/ffmpeg-VERSION.txt')
    end

    it 'download tarball' do
      resource = chef_run.remote_file('Download ffmpeg')
      expect(resource).to do_nothing

      resource = chef_run.file('/opt/source/ffmpeg-VERSION.txt')
      expect(resource).to notify('remote_file[Download ffmpeg]')
    end

    it 'extract' do
      resource = chef_run.tarball('Extract ffmpeg')
      expect(resource).to do_nothing

      resource = chef_run.remote_file('Download ffmpeg')
      expect(resource).to notify('tarball[Extract ffmpeg]')
    end

    it 'execute' do
      resource = chef_run.execute('Install ffmpeg')
      expect(resource).to do_nothing

      resource = chef_run.tarball('Extract ffmpeg')
      expect(resource).to notify('execute[Install ffmpeg]')
    end

    it 'run ldconfig' do
      resource = chef_run.execute('Install ffmpeg')
      expect(resource).to notify('execute[ldconfig]')
    end
  end
end
