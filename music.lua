Music = {
	soundsFiles = {
		'guit9.ogg',
		'guit8.ogg',
		'guit6.ogg',
		'guit1.ogg',
		'guit2.ogg',
		'guit4.ogg',
		'guit3.ogg',
		'guit34.ogg'
	}
}

function Music:load()
	self.sounds = {}
	for _,sndFile in ipairs(self.soundsFiles) do
		local source = love.audio.newSource('snd/'..sndFile)
		source:setLooping(true)
		table.insert(self.sounds,source)
	end
end

function Music:start()
	love.audio.play(self.sounds[game.level.level])
end

function Music:update(dt)
	if(self.sounds[game.level.level]:isStopped()) then
		love.audio.stop()
		love.audio.play(self.sounds[game.level.level])
	end
end
