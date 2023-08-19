-- hooks are ran in alphabetical order, we want ours to run last.
-- use Ø symbol, it is rarely used and ran after Z, should hopefully help with most addon conflictions

-- That is not true at all.. meetric1 what are you doing.
-- Hooks are stored in an unsorted lua table and uses pairs() to loop over them, their order might as well be random.

hook.AddLast("ShouldCollide", "infinite_shouldcollide", function(ent1, ent2)
	if ent1 == game.GetWorld() or ent2 == game.GetWorld() then return end
	if ent1.CHUNK_OFFSET ~= ent2.CHUNK_OFFSET then return false end
end)

hook.AddLast("PhysgunPickup", "infinite_chunkclone_pickup", function(ply, ent)
	if InfMap.disable_pickup[ent:GetClass()] then 
		return false 
	end
end)
