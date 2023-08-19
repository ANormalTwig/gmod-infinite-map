local first = {}
local normal = hook.GetTable()
local last = {}

-- not doing type checking, its only in the normal hook.Add for parity with normal gmod functions, waste of cpu
function hook.AddFirst(name, id, func)
	if not first[name] then
		first[name] = {}
	end
	first[name][id] = func
end
function hook.AddLast(name, id, func)
	if not last[name] then
		last[name] = {}
	end
	last[name][id] = func
end

local badHookIDTypes = {
	["nil"] = true,
	["number"] = true,
	["function"] = true,
	["boolean"] = true,
}
function hook.Add(name, id, func)
	if not type(name) == "string" then return ErrorNoHaltWithStack("bad argument #1 to 'Add' (string expected, got " .. type(name) .. ")") end 
	if not type(func) == "function" then return ErrorNoHaltWithStack("bad argument #3 to 'Add' (function expected, got " .. type(func) .. ")") end

	local idtype = type(id)
	if idtype ~= "string" and (badHookIDTypes[type(id)] or not id.IsValid or not id:IsValid()) then
		return ErrorNoHaltWithStack("bad argument #2 to 'Add' (string expected, got " .. type(id) .. ")")
	end

	if not normal[name] then
		normal[name] = {}
	end
	normal[name][id] = func
end

local function runHook(tbl, name, ...)
	local hooks = tbl[name]
	if not hooks then return end
	for id, func in pairs(hooks) do
		if type(id) == "string" then
			local ret = {func(...)}
			if #ret > 0 then
				return unpack(ret)
			end
		end
	end
end

function hook.Run(name, ...)
	return hook.Call(name, gmod and gmod.GetGamemode() or nil, ...)
end

-- Yeah, the normal gmod function does this too, what the fuck. Too lazy to make a better system. Maybe later.
function hook.Call(name, gm, ...)
	local a, b, c, d, e, f = runHook(first, name, ...)
	if a ~= nil then
		return a, b, c, d, e, f
	end
	a, b, c, d, e, f = runHook(normal, name, ...)
	if a ~= nil then
		return a, b, c, d, e, f
	end
	a, b, c, d, e, f = runHook(last, name, ...)
	if a ~= nil then
		return a, b, c, d, e, f
	end

	if not gm then return end

	local gmFunction = gm[name]
	if not gmFunction then return end

	return gmFunction(gm, ...)
end

-- Not going to replace hook.GetTable() because im lazy, and it's probably not that important.

