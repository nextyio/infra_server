# coding: utf-8

require 'serverspec'
require 'pathname'
require 'net/ssh'
require 'yaml'

set :backend, :ssh
set :path, '/sbin:/usr/sbin:$PATH'

RSpec.configure do |c|
  c.before :all do
    set :host, ENV['TARGET_HOST']
    options = Net::SSH::Config.for(c.host)
    options[:user] = ENV['SSH_USER']
    options[:keys] = ENV['SSH_KEY']

    set :ssh_options, options
  end
end

def send_command(cmd)
  Net::SSH.start(ENV['TARGET_HOST'], ENV['SSH_USER'], :keys => ENV['SSH_KEY']) do |ssh|
    return ssh.exec! cmd
  end
end

def staging?
  hostnamestr = send_command('hostname')
  if hostnamestr.start_with?('stg')
    return true
  else
    return false
  end
end

def product?
  hostnamestr = send_command('hostname')
  if hostnamestr.start_with?('prd')
    return true
  else
    return false
  end
end