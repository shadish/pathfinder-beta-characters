require 'json'

start_value = 10
abilities = ['STR','DEX','CON','INT','WIS','CHR']

mods = JSON::parse File.open('./mods.json').read()
characters = JSON::parse File.open('./characters.json').read()
characters.each do |k,c|
	attributes = Hash.new
	abilities.each{|v| attributes[v] = start_value}
	c['ability_flaws'].each {|f| f['selected'].each {|s| attributes[s] -= 2} }
	c['ability_boosts'].each { |b|
		b['selected'].each {|s| attributes[s] += 2}
		if b.key?('key') && b.key?('name')
			c[b['key']] = b['name']
		end
	}
	c['attributes'] = attributes

	c['name'] = k
	c.delete('ability_flaws')
	c.delete('ability_boosts')

	file_name = "./out/#{k.gsub(/\W/,'_').downcase}.json"
	File.write file_name, JSON::pretty_generate(c)
end