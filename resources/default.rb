property :url, String, required: true
property :checksum, regex: /^[a-zA-Z0-9]{64}$/, default: nil
property :version, String, required: true, name_property: true
property :append_env_path, [true, false], default: false
# TODO: allow overriding the owner/group?
# TODO: Allow specifying if a given eclipse install is "default" (i.e. append_env_path is set?)
# property :owner, String
# property :group, [String, Integer], default: 0
# property :has_binaries, Array, default: []
# property :mode, [Integer, String], default: 0755
# property :prefix_root, String
# property :prefix_home, String
# property :prefix_bin, String
# property :extension, String

default_action :install

def initialize(*args)
  super

  @run_context.include_recipe 'java'
  @run_context.include_recipe 'ark'
end

action :install do
  ark 'eclipse' do
    url new_resource.url
    version new_resource.version
    checksum new_resource.checksum if new_resource.checksum
    has_binaries ['eclipse']
    append_env_path new_resource.append_env_path
    action :install
  end
end
