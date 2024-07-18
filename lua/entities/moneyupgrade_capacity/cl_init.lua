include("shared.lua")

function ENT:Draw(flags)
    self:DrawModel(flags)

    if self:GetFacing() then
        local pos = self:GetPos()
        local ang = self:GetAngles()

        ang:RotateAroundAxis(self:GetUp(), 90)
    
        pos = pos - self:GetForward() * 10
        pos = pos + self:GetRight() * 70
        pos = pos + self:GetUp() * 25

        cam.Start3D2D(pos, ang, 1)
            draw.SimpleText("Модуль вместительности", "Default", 0, 0, color_white)
        cam.End3D2D()
    end
end

function ENT:Think()
    if LocalPlayer():GetEyeTrace().Entity == self then
        self:SetFacing(true)
    elseif self:GetFacing() then
        self:SetFacing(false)
    end
end