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


local function getLevel()
	return game.level.level
end

function Music:load()
	self.sounds = {}
	self.durations = {}
	for _,sndFile in ipairs(self.soundsFiles) do
		local file= 'snd/'..sndFile
		local sd = love.sound.newSoundData(love.sound.newDecoder(file, 1024 * 1024 * 5))
		local length = sd:getSize() / sd:getSampleRate() / sd:getChannels() / (sd:getBits() / 8)
		local source = love.audio.newSource(sd)
		source:setLooping(true)
		table.insert(self.durations, length)
		table.insert(self.sounds,source)
	end
end

function Music:check()
	if self.playing ~= getLevel() then
		love.audio.stop()
		love.audio.play(self.sounds[getLevel()])
		self.playing = getLevel()
		return false
	end
end

function Music:start()
	self.timer = Timer.add(
		self.durations[getLevel()],
		function(func)
			self:check()
			self.timer = Timer.add(self.durations[getLevel()], func)
		end)
	self:check()
end

