describe directory('/usr/local/eclipse') do
  it { should exist }
end

describe directory('/usr/local/eclipse-4.4.2') do
  it { should exist }
  its('mode') { should cmp '0755' }
end

# TODO: test eclipse binary is on PATH?
