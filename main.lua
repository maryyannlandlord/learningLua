local Circle = {}
local Block = {}

local State = {
	idle = 1, 
	jumping = 2 
}


function Circle:new(x, y,color)
    local object = {x=x, y=y, color=color,state = State.idle, radius = 10}
    setmetatable(object,{__index = self})
    return object
end

function Circle:draw()
  love.graphics.setColor(self.color.red/255,self.color.green/255,self.color.blue/255,self.color.alpha)
  love.graphics.circle("fill", self.x,self.y,self.radius)
end

function Circle:startJump()
	if self.state ~= State.jumping then
		self.curTime = time 
		self.jumpTime = 1
		self.state = State.jumping
		self.startY = self.y
	end		 
end

function Circle:animJump(height)

	a = (2 * height) / math.pow((self.jumpTime),2)
	b = (-2 * height) / self.jumpTime
	t = time - self.curTime

	if time < self.curTime + (self.jumpTime) then
		self.y = self.startY + a * t * t + b * t 
		return true 
	-- elseif time < self.curTime + ( self.jumpTime * 2 ) then 
	-- 	self.y = self.y + (dt * speed) 
	-- 	return true 
	else 
		self.y = self.startY
		return false 
	end 

end

function Circle:stateCheck(dt)

	if self.state == State.jumping then
		local notFinish = self:animJump(80)
		if notFinish == false then
			self.state = State.idle 
		end
	end 

end


function Block:new(x, y, width, height, color)
    local object = {x=x, y=y, width = width, height = height, color = color}
    setmetatable(object,{__index = self})
    return object
end

function Block:draw()  
	love.graphics.setColor(self.color.red/255,self.color.green/255,self.color.blue/255,self.color.alpha)
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Block:slide(dt)
	self.x = self.x - dt * 60 
end


function makeRandBlock(blockX)
		rCol = math.random(0,255)
    gCol = math.random(0,255)
    bCol = math.random(0,255)
    blockHeight = 20
    blockWidth = 20
    block = Block:new(blockX,height/2 - blockHeight + char.radius, blockWidth, blockHeight,{red = rCol, green = gCol, blue = bCol})
    return block
end

function makeBlockList(nBlock)
	blockList = {}
	curBlockPos = 20
	for i=1, nBlock do
  	block  = makeRandBlock(width + curBlockPos)
  	curBlockPos = curBlockPos + math.random(70,200) 
  	blockList[i] = block
  end

  return blockList
end

function slideAllBlocks(blockList, dt)
	for i, block in ipairs(blockList) do
		block:slide(dt); 
	end
end

function love.keypressed(key, scancode, isrepeat)

	if key == 'space' then
		char:startJump()
	end

end


function love.load()
	math.randomseed(os.time())
	time = 0
  width, height = love.graphics.getDimensions( )
  char = Circle:new(width/3,height/2,{red = 255, green = 112, blue = 211, alpha = 1 })
  slidingBlocks = makeBlockList(10)
  --char:startJump()
end

function love.draw()
  love.graphics.setBackgroundColor(187/255,227/255,188/255,1)
  love.graphics.setColor(248/255,198/255,15/255,1)
  love.graphics.rectangle("fill", 0, height/2+char.radius, width, height/2- (char.radius))
  char:draw()
  
  for i,block in ipairs(slidingBlocks) do 
  	block:draw()
  end 

end


function love.update(dt)
	time = time + dt
	char:stateCheck(dt)

	slideAllBlocks(slidingBlocks, dt)
end
