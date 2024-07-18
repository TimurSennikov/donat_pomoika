include("shared.lua")

function ENT:Draw(flags)
    self:DrawModel(flags)

    local profit = self:GetProfit()

    local pos = self:GetPos()
    local ang = self:GetAngles()

    pos = pos + self:GetForward() * 20
    pos = pos + self:GetRight() * 45
    pos = pos + self:GetUp() * 100

    ang:RotateAroundAxis(self:GetForward(), 90)
    ang:RotateAroundAxis(self:GetUp(), 90)

    cam.Start3D2D(pos, ang, 1)
        for i=1, profit * 10, 10 do
            local color = Color(i * 10, 255 - i * 10, 0)

            draw.RoundedBox(1, i * 1.1, 0, 10, 10, color)
        end

        draw.SimpleText(self:GetMoneyAmount() .. "$", "Default", 50, 70, Color(0, 255, 0))
    cam.End3D2D()
end

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "MoneyAmount")
    self:NetworkVar("Int", 1, "CustomHealth")

    self:NetworkVar("Int", 2, "Profit")
    self:NetworkVar("Entity", 3, "PreviousCollideEntity")
end