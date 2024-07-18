AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/props_junk/garbage_newspaper001a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local p = self:GetPhysicsObject()

    if IsValid(p) then
        p:Wake()
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Facing")
end