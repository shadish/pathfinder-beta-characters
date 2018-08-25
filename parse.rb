require 'json'
require_relative './parse_attributes'
require_relative './sort_keys'



# def mod(attr, mods)
# 	low = mods.first.values[0]
# 	mods.each do |m|
# 		if m.keys[0].to_i > attr
# 			return low
# 		end
# 		low = m.values[0].to_i
# 	end	
# 	7
# end

characters = JSON::parse File.open('./characters.json').read()
characters.each do |k,c|
	# add name
	c['name'] = k

	# calculate stats
	c = parse_attributes(c)

	# caculate hit points
	hp_mod = c['attributes'].select{|k,v| k === 'CON'}.first.last['mod'].to_i
	c['hit_points'] = c['hit_points']['base'] + hp_mod

	# remove unused properties
	c.delete('ability_flaws')
	c.delete('ability_boosts')

	# sort keys
	c = sort_keys(c)

	# save output
	file_name = "./out/#{k.gsub(/\W/,'_').downcase}.json"
	File.write file_name, JSON::pretty_generate(c)
end