require 'chef/knife'

module Lnxchk
  class Canon < Chef::Knife

    deps do
      require 'chef/mixin/command'
      require 'chef/search/query'
      require 'chef/knife/search'
      require 'chef/knife/ssh'
      require 'net/ssh/multi'
      require 'chef/knife/core/ui'
    end

    banner "knife cannon -C \"good copy\" HOSTS_QUERY COMMAND"

    option :goodcopy,
      :short => '-C CMD',
      :long => '--goodcopy CMD',
      :boolean => false,
      :description => 'Command output expected'
  
    def run
      query = name_args[0]
      command = name_args[1]

      if config[:goodcopy]
        goodcopy = config[:goodcopy]
      else 
        print "Please use -C or --goodcopy to add a master output string"
        exit 1
      end

      knife_ssh = Chef::Knife::Ssh.new

      cmd_line = command
      knife_ssh.name_args = [query, cmd_line]
      stdout_orig = $stdout
      $stdout = File.new('file', 'w')
      knife_ssh.run
      $stdout.close
      $stdout = stdout_orig

      matches = 0

      file = File.open('./file', 'r')
      file.each_line do |line|
        host, data = line.split(" ")
        if data !~ /#{goodcopy}/
          ui.msg(ui.color("ERROR: #{host} failed to match expected output: #{data}", :red) )
        else
          matches = matches + 1
        end
      end
      file.close
      File.delete('file')
      if matches == 1
        match_message = "1 host was successful"
      else 
        match_message = "#{matches} hosts were successful"
      end
      ui.msg(ui.color(match_message, :green))  
    end # close run
  end # close class
end # close module
