local mt = FindMetaTable("Player")

function mt:GetBalance()
    return tonumber(self:GetPData("Balance_Amper", 0))
end

function mt:ChangeBalance(amount)
    self:SetPData("Balance_Amper", self:GetPData("Balance_Amper", 0) + amount)
end