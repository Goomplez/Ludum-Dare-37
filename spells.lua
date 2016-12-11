local sp = {}

function sp.update(self, dt) 
	

end

function spawn_spell(x, y, angle)
	return {
		x = x,
		y = y,
		surface = images["iceball.png"],
		rotation = angle,
		update = sp.update
	}
end