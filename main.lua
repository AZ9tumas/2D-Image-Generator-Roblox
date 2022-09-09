local http = game:GetService("HttpService")
local port = 3000 
local link = "http://localhost:"..port

local module = require(script.Parent.ModuleScript)	

local f = math.floor

local x = 0
local y = 0

local startpos = Vector3.new(-150, 5, 150)
local endpos = Vector3.new(150, 5, -150)

function send(path, data)
	local e = http:JSONEncode(data)
	local r = http:PostAsync(link..path, e, Enum.HttpContentType.ApplicationJson)
	return r
end

-- Get the res

local response = send('/res', {})
response = string.split(response, " ")
local xpix = tonumber(response[1]) -- 10
local zpix = tonumber(response[2]) -- 10
print('res:', xpix, zpix)

local xDistance = startpos.X - endpos.x -- 300
local distance_per_x = math.abs(xDistance / xpix)

local zDistance = startpos.Z - endpos.Z -- 300
local distance_per_z = math.abs(zDistance / zpix)

-- iteration count fix:

local startx = 0
local startz = 0

-- x work
local xItr = distance_per_x
if startpos.X > endpos.X then
	startx = startpos.X - xItr
	xItr = -xItr
else
	startx = startpos.X + xItr
end

-- z work
local zItr = distance_per_z
if startpos.Z > endpos.Z then
	startz = startpos.Z - zItr
	zItr = -zItr
else
	startz = startpos.Z + zItr
end

print(startx, endpos.X, xItr)
print(startz, endpos.Z, zItr)

local MaxPixels = 1000

for x = startx, endpos.X, xItr do

	local PixelData = {
		{} -- row pixel data
	}

	local curr_table_count = 1

	-- Max Pixels in this table will be 1000
	local count = 0
	
	for y = startz, endpos.Z, zItr do

		if count >= MaxPixels then
			-- start adding pixels to another table
			curr_table_count += 1
			table.insert(PixelData, {})
			--print('count', curr_table_count)
			count = 0
		end

		count += 1
		local instance = module:CastRay(x, y)
		local color = instance.Color
		table.insert(PixelData[curr_table_count], {color.R * 255, color.G * 255, color.B * 255, instance.Name, instance.InShade})
		--print(curr_table_count)
	end
	print(';)')
	-- Send the row data to the server
	local response = send('/', {['color'] = PixelData, ['maxPixels'] = MaxPixels})
end

-- End the session
send('/end', {})
print('done')
