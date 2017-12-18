property :url, String, required: true
property :id, String, required: true, name_property: true
property :binary, String, default: 'eclipse'

default_action :install

action :install do
  execute "eclipse plugin install #{new_resource.id}" do
    command "#{new_resource.binary} -application org.eclipse.equinox.p2.director -noSplash -repository #{new_resource.url} -installIUs #{new_resource.id}"
    action :run
    not_if { installed? }
  end
end

action :uninstall do
  execute "eclipse plugin uninstall #{new_resource.id}" do
    command "#{new_resource.binary} -application org.eclipse.equinox.p2.director -noSplash -repository #{new_resource.url} -uninstallIU #{new_resource.id}"
    action :run
    only_if { installed? }
  end
end

action_class do
  def installed?
    ius = shell_out("#{new_resource.binary} -application org.eclipse.equinox.p2.director -noSplash -listInstalledRoots 2>/dev/null").stdout.lines
    ius.any? {|entry| entry.start_with?("#{new_resource.id}/") }
  end
end
