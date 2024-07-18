AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local LIMIT = 3000
local PROFIT_LIMIT = 2

local PAPER_LIMIT = 1000
local PAPER_BOOSTER = 100

local ent_mt = FindMetaTable("Entity")

function ent_mt:ChangeProfit(amount)
    self:SetProfit(self:GetProfit() + amount)
end

function ent_mt:ChangePaperAmount(amount)
    self:SetPaperAmount(self:GetPaperAmount() + amount)
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
    self:SetPaperAmount(1000)
    self:SetProfit(1)

    timer.Create(tostring(math.random(0,10000000000)), 1, 0, function()
        if IsValid(self) then
            local profit = self:GetProfit()
            if self.GetMoneyAmount == nil == false and self:GetMoneyAmount() < LIMIT then
                if self:GetPaperAmount() > 0 then
                    self:SetMoneyAmount(self:GetMoneyAmount() + profit)
                    self:ChangePaperAmount(-profit)
                end
            end
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

    self:NetworkVar("Int", 4, "PaperAmount")
end

function ENT:Touch(ent_toucher)
    if IsValid(ent_toucher) then
        if ent_toucher:GetClass() == "moneyupgrade_profit" and self:GetProfit() < PROFIT_LIMIT then
            if self:GetPreviousCollideEntity() != ent_toucher then
                self:SetPreviousCollideEntity(ent_toucher)
                ent_toucher:Remove()
                self:ChangeProfit(1)
            end
        elseif ent_toucher:GetClass() == "moneyupgrade_paper" and self:GetPaperAmount() <= PAPER_LIMIT - PAPER_BOOSTER then
            if self:GetPreviousCollideEntity() != ent_toucher then
                self:SetPreviousCollideEntity(ent_toucher)
                ent_toucher:Remove()
                self:ChangePaperAmount(PAPER_BOOSTER)
            end
        end
    end
end