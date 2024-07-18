local money = 0
local color = Color(255, 255, 0)

function addPanel()
    local frame = vgui.Create("DFrame")
    frame:SetPos(100,100)
    frame:SetSize(600, 400)
    frame:SetTitle("Система денег")
    frame:MakePopup()

    local text = vgui.Create("DLabel", frame)

    text:SetPos(60,40)
    text:SetSize(600,400)
    text:SetText("На сервер введена система денег!\nКАК это работает?\nТеперь после названий платных оружий пишется их цена\nВаш баланс можно увдеть в верхней левой части экрана или прописав !money\nДеньги можно передавать игрокам командой !sendMoney ник сумма\nПриятной игры на сервере ХлеБушек XL!\nP.S. я знаю что эта менюшка кривая)")
end

concommand.Add("money", addPanel)

function RequestMoneyData()
    net.Start("MONEYREQUEST_Amper")
    net.SendToServer()
end

net.Receive("Money_Amper", function()
    money = net.ReadInt(32)
end)

timer.Create("MoneyUpdateTimer", 1, 0, RequestMoneyData)

hook.Add("HUDPaint", "DrawMoneyAmount", function()
    draw.DrawText("У вас " .. money .. "$", "TargetID", 50 + #tostring(money) * 2, 15, color, TEXT_ALIGN_CENTER)
end)