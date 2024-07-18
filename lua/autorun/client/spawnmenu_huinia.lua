spawnmenu.OldCreateIcon_Amper = spawnmenu.oldCreateIcon_Amper or spawnmenu.CreateContentIcon

prices = {}

net.Receive("Prices", function()
    prices = net.ReadTable()
    RunConsoleCommand("spawnmenu_reload")
end)

function RequestMoneyAmount(name)
    local frame = vgui.Create("DFrame")
    local infoText = vgui.Create("DLabel", frame)
    local numEntry = vgui.Create("DTextEntry", frame)

    frame:Center()

    frame:SetSize(300,100)
    frame:SetTitle("окно ввода цены")
    frame:MakePopup()

    infoText:SetSize(300, 50)
    infoText:SetPos(10, 10)
    infoText:SetText("Введите цену для " .. name)

    numEntry:Dock(BOTTOM)
    numEntry:SetPlaceholderText("100")
    function numEntry:OnEnter(v)
        net.Start("ChangePrice")

        net.WriteString(name)
        net.WriteInt(tonumber(v), 32)

        net.SendToServer()
    end
end

function ResetPrice(name)
    net.Start("ResetPrice")
    net.WriteString(name)
    net.SendToServer()
end

function spawnmenu.CreateContentIcon(type, pnl, data)
    local pricedTool = false
    local price = 0

    if prices[1] then
        for k, v in pairs(prices) do
            if data["spawnname"] and data["spawnname"] == v["name"] then
                price = v["price"]
                pricedTool = true
            end
        end
    end

    ic = spawnmenu.OldCreateIcon_Amper(type, pnl, data)

    if pricedTool then
        local icon = vgui.Create("DImage", ic)
        icon:SetImage("icon16/money.png")
        icon:SetSize(16, 16)
        icon:SetPos(10, 5)

        local text = vgui.Create("DLabel", ic)
        text:SetPos(30, 5)
        text:SetColor(Color(0, 255, 0))
        text:SetText(price .. "$")
    end

    ic.OldOpenMenuExtra_Amper = ic.OldOpenMenuExtra_Amper or ic.OpenMenuExtra

    function ic:OpenMenuExtra(menu)
        self:OldOpenMenuExtra_Amper(menu)

        if LocalPlayer():GetUserGroup() == "superadmin" then -- серверные метафункции не сохраняются на клиенте, поэтому тут не вызвать Player:IsAdmin_Amper()?
            menu:AddSpacer()

            menu:AddOption("Установить цену", function()
                RequestMoneyAmount(self:GetSpawnName())
            end):SetIcon("icon16/add.png")

            if pricedTool then
                menu:AddOption("Сбросить цену", function()
                    ResetPrice(data["spawnname"])
                end):SetIcon("icon16/delete.png")
            end
        end
    end

    return ic
end