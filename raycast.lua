local module = {}

function module:CastRay(x,y)
	
	local finalx = x
	local finalz = y
	
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
