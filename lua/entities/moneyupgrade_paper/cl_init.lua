include("shared.lua")

function ENT:Draw(flags)
    self:DrawModel(flags)

    if self:GetFacing() then
        local pos = self:GetPos()
        local ang = self:GetAngles()
    
        ang:RotateAroundAxis(self:GetUp(), 90)
    
        pos = pos - self:GetForward() * 10
        pos = pos + self:GetRight() * 70
        pos = pos + self:GetUp() * 5
    
        cam.Start3D2D(pos, ang, 1)
            draw.DrawText("(X100) Печатная бумага", "Default", 0, 0, color_white)
        cam.End3D2D()
    end
end

function ENT:Think()
    local eyeTrace = LocalPlayer():GetEyeTrace()

    if IsValid(eyeTrace.Entity) and eyeTrace.Entity == self then
        self:SetFacing(true)
    else
        if self:GetFacing() then
            self:SetFacing(false)
        end
    end
end

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Facing")
end