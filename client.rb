require './PingdomAPIClient.rb'
require 'optparse'

options = {
	:type =>'http',
	:resolution =>'1',
	:contactids =>'336599',
	:paused => 'false'
}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  
  opts.on("-i", "--checkid <CheckID>",Integer, "Check ID to Delete") do |id|
    options[:id] = id
  end

  opts.on("-a", "--action <action_type>",[:create, :delete, :list],String, "Choose Action") do |action|
    options[:action] = action
  end

  opts.on("-h", "--host <url>",String, "The URL you want to monitor") do |host|
    options[:host] = host
  end

  opts.on("-n", "--name <check_name>",String, "A Name for the new check") do |name|
    options[:name] = name
  end

  opts.on("-r", "--resolution <minutes>",['1', '5', '15'],Integer, "Define Interval for monitoring") do |resolution|
    options[:resolution] = resolution
  end

  opts.on("-p", "--paused <boolean>",[:true, :false], "Create in Paused Mode") do |paused|
    options[:paused] = paused
  end

  opts.on("-c", "--contactids <id1,id2,id3>",Integer, "Contact IDs for Alerts") do |contactids|
    options[:contactids] = contactids
  end

end.parse!

def actioner(params={})
	conn = PingdomAPIClient.new()
	if params[:action]=='delete'
		if (params[:id]!=nil) && (params[:id].is_a? Integer)
			conn.delete_check(params[:id])
		else
			puts "\nERROR: Missing check_id, Please specify it using the -i parameter. \n i.e. client.rb --action delete -i 1385577 \n\n"
		end
	elsif params[:action]=='create' 
		if (params[:name]!=nil) && (params[:host]!=nil)
			conn.create_http_check(params[:name],params[:host],'http',params[:resolution],params[:contactids],params[:paused])
		else
			puts "\nERROR: Missing Parameters, Please make sure that you have both -h for URL and -n for Name. \n i.e. client.rb --action create -h http://www.smilarweb.com -n ""Similarweb Homepage"" \n\n"
		end		
	elsif params[:action]=='list'
		conn.get_all_checks
	else
		puts "ERROR: No Such Action. Please choose delete, create or list."
	end
end

actioner(options)
#p options
#p ARGV