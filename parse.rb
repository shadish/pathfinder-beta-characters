require 'json'

start_value = 10
abilities = ['STR','DEX','CON','INT','WIS','CHR']
mods = JSON::parse File.open('./mods.json').read()

def mod(attr, mods)
	low = mods.first.values[0]
	mods.each do |m|
		if m.keys[0].to_i > attr
			return low
		end
		low = m.values[0].to_i
	end	
	7
end

characters = JSON::parse File.open('./characters.json').read()
characters.each do |k,c|
	attributes = Hash.new

	abilities.each{|v| attributes[v] = { "base" => start_value, "mod" => 0}}

	c['ability_flaws'].each {|f| f['selected'].each {|s| attributes[s]["base"] -= 2} }
	c['ability_boosts'].each { |b|
		b['selected'].each {|s| attributes[s]["base"] += 2}
		if b.key?('key') && b.key?('name')
			c[b['key']] = b['name']
		end
	}

	attributes.each do |k,v|
		v["mod"] = mod(v["base"].to_i, mods)
	end

	c['attributes'] = attributes

	c['name'] = k
	c.delete('ability_flaws')
	c.delete('ability_boosts')

	file_name = "./out/#{k.gsub(/\W/,'_').downcase}.json"
	File.write file_name, JSON::pretty_generate(c)
end