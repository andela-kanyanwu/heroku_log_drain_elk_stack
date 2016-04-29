require 'open3'

Given(/^I have a running server$/) do
  output, error, status = Open3.capture3 "vagrant reload"

  expect(status.success?).to eq(true)
end

And(/^I provision it$/) do
  output, error, status = Open3.capture3 "vagrant provision"

  expect(status.success?).to eq(true)
end

When(/^I install elasticsearch$/) do
  cmd = "ansible-playbook -i inventory.ini --private-key=.vagrant/machines/elkserver/virtualbox/private_key -u vagrant playbook.elasticsearch.yml"
  output, error, @status = Open3.capture3 "#{cmd}"
end

Then(/^it should be successful$/) do
  expect(@status.success?).to eq(true)
end

=begin
# This is for elasticsearch, logstash and kibana
And(/^([^"]*) should be running$/) do |pkg|
  case pkg
  when 'elasticsearch', 'logstash', 'kibana'
    output, error, status = Open3.capture3 "vagrant ssh -c 'sudo service #{pkg} status'"

    expect(status.success?).to eq(true)
    expect(output).to match("#{pkg} is running")
  else
    raise 'Not Implemented'
  end
end
=end
Then(/^elasticsearch should be running$/) do
    output, error, status = Open3.capture3("vagrant ssh -c 'sudo service elasticsearch status'")

    expect(status.success?).to eq(true)
    expect(output).to match("elasticsearch is running")
end

And(/^it should be accepting connections on port ([^"]*)$/) do |port|
  output, error, status = Open3.capture3 "vagrant ssh -c 'curl -f http://localhost:#{port}'"

  expect(status.success?).to eq(true)
end