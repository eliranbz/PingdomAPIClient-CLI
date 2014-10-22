require 'faraday'
require 'json'

class PingdomAPIClient

	def initialize(url='https://api.pingdom.com',pingdom_user='<PINGDOM_USERNAME_HERE>',pingdom_pass='<PINGDOM_PASSWORD_HERE>',appkey='<PINGDOM_APPKEY_HERE>')
		@conn = Faraday.new(:url => url)
		@conn.basic_auth(pingdom_user, pingdom_pass)
		@conn.headers['App-Key'] = appkey
		#puts "A new Pingdom Client has been instantiated"
	end

	def get_all_checks
		result = @conn.get '/api/2.0/checks'
		res = JSON.parse(result.body)
		puts "#ID[STATUS]" + "\t" +"#HOSTNAME" + "\t" + "#NAME"
		res['checks'].each do |c|
	   		puts c['id'].to_s + "[" + c['status'] + "]" + "\t" + c['hostname'] + "=>  " + c['name']
		end; nil
	end

	def create_http_check(name,host,type='http',resolution=1,contactids='<DEFAULT_CONTACT_ID>',paused=false)
		result = @conn.post '/api/2.0/checks', { :name => name , :host => host , :type => type , :resolution => resolution , :paused => paused , :contactids => contactids}
		res = JSON.parse(result.body)
		return result_validator(result.status,"New check has been added! ID: #{res['check']['id']}","#{res['check']['name']} has been added.") 
	end

	def delete_check(delcheckids)
		result = @conn.delete '/api/2.0/checks', { :delcheckids => delcheckids}
		res = JSON.parse(result.body)
		return result_validator(result.status,res['message'],delcheckids) 
	end

	def result_validator(returncode,message="",moreinfo="")
		if returncode==200
			puts "Return Code: #{returncode} , Output: #{message} , More Info: #{moreinfo}"
		elsif 
			puts "Return Code: #{returncode} , Output: #{message} , More Info: Something went wrong! Please investigate."
		end
			
	end

end