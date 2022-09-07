local module = {}

local light_direction = workspace.light.Position

function module:CastRay(x,y)
	
	local finalx = x--module.startXpos - i
	local finalz = y--module.startZpos + j
	
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {workspace.light}
	params.IgnoreWater = false
	
	local rayResult = workspace:Raycast(Vector3.new(finalx, 100, finalz), Vector3.new(0, -1000, 0), params)
	if rayResult and rayResult.Instance then
		
		-- cast another ray and check the lighting
		local lightRayCast = workspace:Raycast(rayResult.Position, light_direction, params)
		
		local color
		
		if rayResult.Instance:IsA("BasePart") and rayResult.Instance ~= workspace.Terrain then
			color = rayResult.Instance.BrickColor.Color
		elseif rayResult.Instance == workspace.Terrain then
			-- terrain work
			local terrainType = rayResult.Material
			color = terrainType == Enum.Material.Water and workspace.Terrain.WaterColor or workspace.Terrain:GetMaterialColor(terrainType)
			--print('terrain color: ', color)
		end
		
		return {Color = color, Name = rayResult.Instance.Name, InShade = lightRayCast ~= nil}
	else
		return {Color = Color3.new(0, 0.560784, 0.839216), Name = 'NAn', InShade = false}
	end
end

return module
