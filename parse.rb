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

	# calculate AC
	c['ac'] = 10 + get_mod(c,'DEX')
	c['ac-touch'] = 10 + get_mod(c,'DEX')
	#TODO: page 16 TAC with armor

	#TODO: page 17 weapon strike/ranged with weapon prof.

	# bulk
	c['bulk'] = {
		:encumbered => 5 + get_mod(c,'STR'),
		:max => 10 + get_mod(c,'STR')
	}

	# points
	c['hero_points'] = 1
	c['resonance_points'] = c['levels'].length + get_mod(c,'CHR') 

	 c['level'] =  c['levels'].length 

	# perception
	#TODO: preception prof. + WIS mod	

	c['saving_throws'] = {
		'fortitude' => get_mod(c,'CON'),
		'reflex' => get_mod(c,'DEX'),
		'will' => get_mod(c,'WIS')
	}

	# remove unused properties
	c.delete('ability_flaws')
	c.delete('ability_boosts')
	c.delete('levels')

	# sort keys
	c = sort_keys(c)

	# save output
	file_name = "./out/#{k.gsub(/\W/,'_').downcase}.json"
	File.write file_name, JSON::pretty_generate(c)
end