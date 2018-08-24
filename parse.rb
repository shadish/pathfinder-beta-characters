require 'json'

start_value = 10
abilities = ['STR','DEX','CON','INT','WIS','CHR']

characters = JSON::parse File.open('./characters.json').read()
characters.each do |k,c|
	puts k
	# attributes = Hash.new
	# abilities.each{|v| attributes[v] = start_value}
	# c['ability_flaws'].each {|f| f['selected'].each {|s| attributes[s] -= 2} }
	# c['ability_boosts'].each {|b| b['selected'].each {|s| attributes[s] += 2} }
	# puts attributes
end