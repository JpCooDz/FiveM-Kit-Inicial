-- Este código implementa um kit inicial para servidores da Academy no FiveM, garantindo que cada jogador possa resgatar o kit apenas uma vez. Além disso, inclui a atribuição de um carro VIP por 30 dias

----------------------------------------------------------------------------------------------------------------------------------------
-- KIT INICIAL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("kit", function(source)
    local user_id = vRP.getUserId(source)
    if user_id then
        local data = vRP.getUData(user_id, "vRP:kit")
        local kit = json.decode(data) or 0
        if kit == 0 then
            TriggerClientEvent("chatMessage", source, "^1[SERVIDOR]", {255, 255, 255}, "Digite 'sim' no chat para confirmar o resgate do seu Kit Inicial.")
            local response = vRP.prompt(source, "", 30)
            if response then
                if string.lower(response) == "sim" then
                    TriggerClientEvent("Notify", source, "sucesso", "Você resgatou seu Kit Inicial.", 10000)
                    vRP.setUData(user_id, "vRP:kit", 1)
                    vRPclient.giveWeapons(source, {["WEAPON_PISTOL_MK2"] = {ammo = 250}})
                    vRP.giveInventoryItem(user_id, "compattach", 1)
                    vRP.giveInventoryItem(user_id, "radio", 1)
                    vRP.giveInventoryItem(user_id, "mochila", 3)
                    vRP.giveInventoryItem(user_id, "energetico", 10)
                    vRP.giveInventoryItem(user_id, "bandagem", 5) -- Adiciona 5 bandagens
                    vRP.giveInventoryItem(user_id, "repairkit", 3) -- Adiciona 3 kits de reparo
                    vRP.giveInventoryItem(user_id, "maconha", 50) -- Adiciona 50 unidades de maconha
                    
                    local expiration_time = os.time() + (30 * 24 * 60 * 60)
                    vRP.setUData(user_id, "vRP:carro_vip_expiracao", expiration_time)
                    TriggerClientEvent("Notify", source, "sucesso", "Você recebeu um Nissan GTR como carro VIP por 30 dias.", 10000)
                    
                    -- Adiciona o Nissan GTR à garagem do jogador
                    vRP.execute("creative/add_vehicle",{ user_id = user_id, vehicle = "nissangtr", ipva = os.time() })

                    -- Agendar a remoção do carro VIP após 30 dias
                    SetTimeout(30 * 24 * 60 * 60 * 1000, function()
                        -- Verifica se o carro ainda está na garagem do jogador
                        local vehicle_data = vRP.getUData(user_id, "vRP:vehicle_data")
                        local vehicle_list = json.decode(vehicle_data) or {}
                        if vehicle_list["nissangtr"] then
                            -- Remove o Nissan GTR da garagem do jogador
                            vRP.execute("creative/rem_vehicle",{ user_id = user_id, vehicle = "nissangtr", ipva = os.time() })
                            TriggerClientEvent("Notify", source, "informacao", "Seu carro VIP foi removido após o término do período de 30 dias.", 10000)
                        end
                    end)
                else
                    TriggerClientEvent("Notify", source, "negado", "Você não confirmou o resgate do Kit Inicial.", 10000)
                end
            else
                TriggerClientEvent("Notify", source, "negado", "Tempo esgotado. Você não confirmou o resgate do Kit Inicial.", 10000)
            end
        else
            TriggerClientEvent("Notify", source, "negado", "Você já resgatou seu Kit Inicial.", 10000)
        end
    end
end)
