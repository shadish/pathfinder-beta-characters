require 'json'
require_relative './parse_attributes'
require_relative './sort_keys'

def get_mod(c, mod)
	c['attributes'].select{|k,v| k === mod}.first.last['mod'].to_i
end

characters = JSON::parse File.open('./characters.json').read()
characters.each do |k,c|
	# add name
	c['name'] = k

	# calculate stats
	c = parse_attributes(c)

	# caculate hit points
	hp_mod = get_mod(c,'CON')
	c['hit_points'] = c['hit_points']['base'] + hp_mod

	# remove unused properties
	c.delete('ability_flaws')
	c.delete('ability_boosts')

	# calculate AC
	c['ac'] = 10 + get_mod(c,'DEX')
	c['ac-touch'] = 10 + get_mod(c,'DEX')
	#TODO: page 16 TAC with armor

	# sort keys
	c = sort_keys(c)

	# save output
	file_name = "./out/#{k.gsub(/\W/,'_').downcase}.json"
	File.write file_name, JSON::pretty_generate(c)
end