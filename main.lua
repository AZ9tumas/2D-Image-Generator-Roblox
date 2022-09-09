local http = game:GetService("HttpService")
local port = 3000 
local link = "http://localhost:"..port
local module = require(script.Parent.ModuleScript)
local f = math.floor
local startpos = Vector3.new(-200, -35, 200)
local endpos = Vector3.new(200, -35, -200)

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


-- x work
local xItr = distance_per_x
if startpos.X > endpos.X then
	xItr = -xItr
end

-- z work
local zItr = distance_per_z
if startpos.Z > endpos.Z then
	zItr = -zItr
end

-- Debug
print(startpos.X,',', endpos.X,',', xItr)
print(startpos.Z,',', endpos.Z,',', zItr)

-- Max pixels in each table
local MaxPixels = 1000
local x = startpos.X

local function xwork()
	-- The entire table contains rows which each have a max of (maxPixels) pixels
	local PixelData = {
		{}
	}

	local curr_table_count = 1 -- Insert the pixel info into this index of the main table

	local count = 0 -- Keep track of the number of pixels in the sub table

	local y = startpos.Z -- Initializing the y coordinate

	while count + MaxPixels * (curr_table_count - 1) < zpix do

		-- Split Pixel data into two tables so the size can be handelled
		if count >= MaxPixels then
			curr_table_count += 1
			table.insert(PixelData, {})

			count = 0
		end

		-- Get the color from the ray
		local instance = module:CastRay(x, y)
		local color = instance.Color
		table.insert(PixelData[curr_table_count], {(color.R) * 255, (color.G) * 255, (color.B) * 255, instance.Name, instance.InShade})

		-- Incrementing stuff
		y += zItr
		count += 1
	end
	-- Send the row data to the server

	-- Instead of sending the entire PixelData (which conatains tables with 1000+ elements each), we can
	-- just send each of the table individually (which means no of reqs sent per pixel scan = curr_table_count

	for _, row_data in pairs(PixelData) do
		local response = send('/', {['color'] = row_data, ['maxPixels'] = MaxPixels, ['maxitr'] = #row_data})
	end

	return y
end

local xcount = 0

local yinfo

while xcount < xpix do -- xcount < 1200 (0 -> 1199) total itr count = 1199 - 0 + 1 = 1200
	yinfo = xwork()
	print(';)', yinfo)
	x += xItr
	xcount += 1
end

print('(', x, ',', yinfo, ')')

-- End the session
send('/end', {})
print('done')
