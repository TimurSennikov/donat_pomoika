ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Майнинг ферма"
ENT.Author = "40 ампер мощи"
ENT.Category = "Amper`s stuff"
ENT.Spawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "MoneyAmount")
    self:NetworkVar("Int", 1, "CustomHealth")

    self:NetworkVar("Int", 2, "Profit")
    self:NetworkVar("Entity", 3, "PreviousCollideEntity")

    self:NetworkVar("Int", 4, "PaperAmount")

    self:NetworkVar("Int", 5, "Capacity")
end