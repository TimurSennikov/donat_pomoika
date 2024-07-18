util.AddNetworkString("Money_Amper")
util.AddNetworkString("MONEYREQUEST_Amper")

net.Receive("MONEYREQUEST_Amper", function(len, ply)
    net.Start("Money_Amper")

    net.WriteInt(ply:GetBalance(), 32)
    net.Send(ply)
end)

function ProcessWeaponGive(ply, weapon)
    local prices = sql.Query("SELECT * FROM prices_table")

    if prices and prices[1] and not ply:HasWeapon(weapon) then
        for k, v in pairs(prices) do
            if v["name"] == weapon then
                local balance = tonumber(ply:GetBalance())
                local price = tonumber(v["price"])

                if balance >= price then
                    ply:ChangeBalance(-price)
                    return true
                else
                    ply:PrintMessage(HUD_PRINTTALK, "Вам не хватает " .. price - balance .. "$ на покупку ".. weapon .. ".")
                    return false
                end
            end
        end
    end
end

function ProcessWeaponSpawn(ply, weapon)
    local prices = sql.Query("SELECT * FROM prices_table")

    if prices and prices[1] and not ply:HasWeapon(weapon) then
        for k, v in pairs(prices) do
            if v["name"] == weapon then
                local balance = ply:GetBalance()
                local price = tonumber(v["price"])

                if balance >= price then
                    ply:ChangeBalance(-price)
                    return true
                else
                    ply:PrintMessage(HUD_PRINTTALK, "Вам не хватает " .. price - balance .. "$ на покупку ".. weapon .. ".")
                    return false
                end
            end
        end
    end

    return true
end

function ProcessSENTSpawn(ply, class)
    local prices = sql.Query("SELECT * FROM prices_table")

    if prices and prices[1] then
        for k, v in pairs(prices) do
            if v["name"] == class then
                local balance = tonumber(ply:GetBalance())
                local price = tonumber(v["price"])

                if balance >= price then
                    ply:ChangeBalance(-price)
                    return true
                else
                    ply:PrintMessage(HUD_PRINTTALK, "Вам не хватает " .. price - balance .. "$ на покупку ".. class .. ".")
                    return false
                end
            end
        end
    end

    return true
end

function ProcessVehicleSpawn(ply, model, name)
    local prices = sql.Query("SELECT * FROM prices_table")

    for k, v in pairs(prices) do
        if v["name"] == name then
            local balance = tonumber(ply:GetBalance())
            local price = tonumber(v["price"])

            if balance >= price then
                ply:ChangeBalance(-price)
                return true
            else
                ply:PrintMessage(HUD_PRINTTALK, "Вам не хватает " .. price - balance .. "$ на покупку ".. name .. ".")
            end
        end
    end

    return true
end

function ProcessDupe(data, time) -- не используется, можно удалить, оставил для себя.
    local prices = sql.Query("SELECT * FROM prices_table")

    if prices and prices[1] then
        for _, v in pairs(data) do
            local ply = v["Player"]

            for l, m in pairs(v["CreatedEntities"]) do
                local ent = m
                local class = ent:GetClass()

                for g, c in pairs(prices) do
                    if class == c["name"] then
                        if ply:GetBalance() >= c["price"] then
                            ply:ChangeBalance(-c["price"])
                        else
                            ent:Remove()
                        end
                    end
                end
            end
        end
    end
end

function ProcessKill(victim, inflictor, attacker)
    if IsValid(victim) and IsValid(attacker) and victim:IsPlayer() and attacker:IsPlayer() then
        attacker:ChangeBalance(100)
    end
end

function SendMoneyP2P(from, to, amount)
    if IsValid(from) and IsValid(to) and from:IsPlayer() and to:IsPlayer() and amount > 0 then
        if from:GetBalance() >= amount then
            from:ChangeBalance(-amount)
            to:ChangeBalance(amount)

            from:PrintMessage(HUD_PRINTTALK, "Вы отправили " .. amount .. "$ игроку " .. to:Name() .. ".")
            to:PrintMessage(HUD_PRINTTALK, "Вы получили " .. amount .. "$ от игрока " .. from:Name() .. ".")
        else
            from:PrintMessage(HUD_PRINTTALK, "Введенное число слишком большое.")
        end
    else
        from:PrintMessage(HUD_PRINTTALK, "Произошла ошибка при обработке команды.")
    end
end

function ChatCommands(ply, text)
    local splittedText = string.Explode('"', text)
    local spaceSplittedText = string.Explode(" ", text)

    if spaceSplittedText[1] == "!changebalance" and ply:IsAdmin_Amper() then
        local amount = tonumber(spaceSplittedText[2])

        if ply:GetBalance() + amount >= 0 then
            ply:ChangeBalance(tonumber(spaceSplittedText[2]))
        end
    elseif splittedText[1] == "!sendmoney " and splittedText[2] and splittedText[3] then
        local toName = splittedText[2]

        for k, v in pairs(player.GetAll()) do
            if toName == v:Name() then
                SendMoneyP2P(ply, v, tonumber(splittedText[3]))
            end
        end

        return ""
    elseif splittedText[1] == "!changeplayermoney " and #splittedText == 3 and ply:IsAdmin_Amper() then
        local toName = splittedText[2]
        local amount = tonumber(splittedText[3])

        for k, v in pairs(player.GetAll()) do
            if v:Name() == toName then
                if amount < 0 then
                    if v:GetBalance() >= amount then
                        v:ChangeBalance(amount)
                    else
                        v:ChangeBalance(-v:GetBalance())
                    end
                elseif amount > 0 then
                    v:ChangeBalance(amount)
                end

                ply:PrintMessage(HUD_PRINTTALK, "Выполнено, новый баланс игрока " .. v:Name() .. ": " .. v:GetBalance())
            end
        end

        return ""
    elseif text == "!resetmoney" then
        ply:ChangeBalance(-ply:GetBalance())
    end
end

hook.Add("PlayerSay", "CommandProcessHook", ChatCommands)

hook.Add("PlayerDeath", "PlayerDeathHook", ProcessKill)

hook.Add("PlayerGiveSWEP", "WeaponBuyHook", ProcessWeaponGive)
hook.Add("PlayerSpawnSWEP", "WeaponBuy-SpawnHook", ProcessSENTSpawn)
hook.Add("PlayerSpawnSENT", "SENTBuy-SpawnHook", ProcessSENTSpawn)

hook.Add("PlayerSpawnVehicle", "VehicleSpawn-BuyHook", ProcessVehicleSpawn)

-- спавн на землю свепа - DONE
-- перевод денег - DONE
-- платный спавн на землю - DONE
-- пофиксить