AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local LIMIT = 3000
local PROFIT_LIMIT = 2

local ent_mt = FindMetaTable("Entity")

function ent_mt:ChangeProfit(amount)
    self:SetProfit(self:GetProfit() + amount)
end

function ENT:Initialize()
    self:SetModel("models/props_lab/servers.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    local p = self:GetPhysicsObject()

    if p:IsValid() then
        p:Wake()
    end

    self:SetMoneyAmount(0)
    self:SetProfit(1)

    timer.Create(tostring(math.random(0,10000000000)), 1, 0, function()
        if self.GetMoneyAmount == nil == false and self:GetMoneyAmount() < LIMIT then
            self:SetMoneyAmount(self:GetMoneyAmount() + self:GetProfit())
        end
    end)

    self:SetCustomHealth(500)
end

function ENT:OnDuplicated()
    self:SetMoneyAmount(0)
    self:SetProfit(1)
end

function ENT:Use(activator)
    if activator:IsPlayer() then
        activator:SetPData("Balance_Amper", activator:GetPData("Balance_Amper", 0) + self:GetMoneyAmount())
        self:SetMoneyAmount(0)

        self:EmitSound("ambient/levels/labs/coinslot1.wav")
    end
end

function ENT:OnTakeDamage(dmginfo)
    self:SetCustomHealth(self:GetCustomHealth() - dmginfo:GetDamage())

    if self:GetCustomHealth() <= 0 then
        self:EmitSound("ambient/energy/zap1.wav")
        self:Remove()
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "MoneyAmount")
    self:NetworkVar("Int", 1, "CustomHealth")

    self:NetworkVar("Int", 2, "Profit")
    self:NetworkVar("Entity", 3, "PreviousCollideEntity")
end

function ENT:Touch(ent_toucher)
    if IsValid(ent_toucher) and ent_toucher:GetClass() == "moneyupgrade_profit" and self:GetProfit() < PROFIT_LIMIT then
        print(self:GetPreviousCollideEntity())
        if self:GetPreviousCollideEntity() != ent_toucher then
            self:SetPreviousCollideEntity(ent_toucher)
            ent_toucher:Remove()
            self:ChangeProfit(1)
        end
    end
end