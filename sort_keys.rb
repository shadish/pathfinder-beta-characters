
def sort_keys(c)
	ordinal = ['chapter', 'name', 'ancestry', 'age', 'background', 'class', 'class_details', 'attributes']
	c.sort_by { |k,v| (ordinal.index(k) || 999) }.to_h
end