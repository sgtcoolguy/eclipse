# Common properties
property :url, String, required: true, name_property: true
property :binary, String, default: 'eclipse'
# What is the ultimate zipfile generated for :generate?
# What is the destination eclipse install to install delta pack into? (i.e. /usr/local/eclipse)
property :destination, String

# Used by install, checksum of remote delta pack zipfile from URL
property :checksum, regex: /^[a-zA-Z0-9]{64}$/, default: nil

default_action :generate

def initialize(*args)
  super

  @run_context.include_recipe 'ark'
end

action :generate do
  xml = ::File.join(Chef::Config[:file_cache_path], 'createdeltapack.xml')
  template xml do
    cookbook 'eclipse'
    variables lazy {
      {
        buildRepo: new_resource.url,
      }
    }
  end

  execute "generate delta pack for #{new_resource.url}" do
    command "#{new_resource.binary} -application org.eclipse.ant.core.antRunner -f #{xml} -noSplash"
    cwd Chef::Config[:file_cache_path]
    action :run
  end

  # This generates a:
  # - rcp.deltapack folder we can blow away
  # - results/eclipse-latestIBuild-delta-pack.zip (what we want!)
  # - workspace folder we an blow away

  # Delete the generated ant xml file
  file xml do
    action :delete
  end

  directory "#{Chef::Config[:file_cache_path]}/rcp.deltapack" do
    action    :delete
    recursive true
  end

  directory "#{Chef::Config[:file_cache_path]}/workspace" do
    action    :delete
    recursive true
  end

  execute "Move generated delta pack zipfile to #{destination}" do
    command "mv #{Chef::Config[:file_cache_path]}/results/eclipse-latestIBuild-delta-pack.zip #{new_resource.destination}"
    action :run
  end
end

action :install do
  # FIXME: Generate unique name based on url?
  folder_name = 'eclipse-delta-pack'
  full_path = ::File.join(Chef::Config[:file_cache_path], folder_name)

  # FIXME: On windows use sevenzip_archive? Specify win_install_dir?
  ark folder_name do
    url new_resource.url
    checksum new_resource.checksum if new_resource.checksum
    path Chef::Config[:file_cache_path]
    action :put
  end

  # Copy the delta pack from cache dir out to destination
  if platform?('windows')
    # https://github.com/chef/chef/issues/4909 Due to this issue, need to run a regular expression on the cached path for windows
    execute "xcopy \"#{full_path.gsub(%r{/}, '\\')}\\plugins\" \"#{new_resource.destination}\\plugins\" /s /i"
    execute "xcopy \"#{full_path.gsub(%r{/}, '\\')}\\features\" \"#{new_resource.destination}\\features\" /s /i"
  else
    execute "sudo cp -r \"#{full_path}/plugins/.\" \"#{new_resource.destination}/plugins/\""
    execute "sudo cp -r \"#{full_path}/features/.\" \"#{new_resource.destination}/features/\""
  end

  directory full_path do
    action    :delete
    recursive true
  end
end
