ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Обновление вместительности"
ENT.Author = "40 ампер мощи"
ENT.Category = "Amper`s stuff"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Bool", 0, "Facing")
end