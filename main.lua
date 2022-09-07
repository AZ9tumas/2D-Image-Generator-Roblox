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

print(startpos.X, endpos.X, distance_per_x)
print(startpos.Z, endpos.Z, distance_per_z)

print(xDistance, zDistance)

local total_itr_count = 0
local x_itr = 0
local y_itr = 0

for x = startpos.X + distance_per_x, endpos.X, distance_per_x do

	local row_pixel_data = {}
	
	x_itr += 1
	
	local didYwork = false
	for y = startpos.Z - distance_per_z, endpos.Z, -distance_per_z do
		didYwork = true
		total_itr_count += 1
		y_itr += 1
		local instance = module:CastRay(x, y)
		local color = instance.Color
		table.insert(row_pixel_data, {color.R * 255, color.G * 255, color.B * 255, instance.Name, instance.InShade})
	end
	if not didYwork then warn('y did not work') end
	print(y_itr)
	y_itr = 0
	-- Send the row data to the server
	local response = send('/', {['color'] = row_pixel_data})
end

-- End the session
send('/end', {})
print('done')

print('total itr count:',total_itr_count)
print('x count', x_itr)
