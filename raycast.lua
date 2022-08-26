local module = {}

--// Raycast through the entire baseplate

module.startXpos = 50
module.endXpos = -50

module.startZpos = -50
module.endZpos = 50

function module:CastRay(x,y)
	-- return in {r, g, b}
	
	-- i in range of [1, 100]
	-- j in range of [0, 099]
	
	local finalx = x--module.startXpos - i
	local finalz = y--module.startZpos + j
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {workspace.SpawnLocation}
	params.IgnoreWater = true
	
	local rayResult = workspace:Raycast(Vector3.new(finalx, 100, finalz), Vector3.new(0, -1000, 0), params)
	
	if rayResult and rayResult.Instance and rayResult.Instance:IsA("BasePart") then
		--print(x, y)
		return rayResult.Instance
	else
		return {Color = Color3.new(0, 0.560784, 0.839216), Name = 'NAn'}
	end
end

return module
