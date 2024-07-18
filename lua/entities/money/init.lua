AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local LIMIT = 3000
local PROFIT_LIMIT = 2

local PAPER_LIMIT = 1000
local PAPER_BOOSTER = 100

local UPGRADE_SOUND = "items/suitchargeok1.wav"
local WITHDRAW_SOUND = "ambient/levels/labs/coinslot1.wav"
local PAPER_INSERT_SOUND = "npc/dog/dog_footsteps_run3.wav"
local BREAK_SOUND = "ambient/energy/zap1.wav"

function ChangeProfit(ent, amount)
    ent:SetProfit(ent:GetProfit() + amount)
end

function ChangePaperAmount(ent, amount)
    ent:SetPaperAmount(ent:GetPaperAmount() + amount)
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
    self:SetFacing(false)

    timer.Create(tostring(math.random(0,10000000000)), 1, 0, function()
        if IsValid(self) then
            local profit = self:GetProfit()
            if self:GetMoneyAmount() < LIMIT then
                if self:GetPaperAmount() > 0 then
                    self:SetMoneyAmount(self:GetMoneyAmount() + profit)
                    ChangePaperAmount(self, -profit)
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

        self:EmitSound(WITHDRAW_SOUND)
    end
end

function ENT:OnTakeDamage(dmginfo)
    self:SetCustomHealth(self:GetCustomHealth() - dmginfo:GetDamage())

    if self:GetCustomHealth() <= 0 then
        self:EmitSound(BREAK_SOUND)
        self:Remove()
    end
end

function ENT:Touch(ent_toucher)
    if IsValid(ent_toucher) then
        if ent_toucher:GetClass() == "moneyupgrade_profit" and self:GetProfit() < PROFIT_LIMIT then
            if self:GetPreviousCollideEntity() != ent_toucher then
                self:SetPreviousCollideEntity(ent_toucher)
                ent_toucher:Remove()
                ChangeProfit(self, 1)
                self:EmitSound(UPGRADE_SOUND)
            end
        elseif ent_toucher:GetClass() == "moneyupgrade_paper" and self:GetPaperAmount() <= PAPER_LIMIT - PAPER_BOOSTER then
            if self:GetPreviousCollideEntity() != ent_toucher then
                self:SetPreviousCollideEntity(ent_toucher)
                ent_toucher:Remove()
                ChangePaperAmount(self, PAPER_BOOSTER)
                self:EmitSound(PAPER_INSERT_SOUND)
            end
        end
    end
end