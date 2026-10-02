local ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    for _, v in pairs(Config.Dealership.Positions) do
        local blip = AddBlipForCoord(v.x, v.y, v.z)
        SetBlipSprite(blip, Config.Dealership.Blip.Sprite)
        SetBlipColour(blip, Config.Dealership.Blip.Color)
        SetBlipScale(blip, Config.Dealership.Blip.Scale)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('Car Dealership')
        EndTextCommandSetBlipName(blip)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, v in pairs(Config.Dealership.Positions) do
            local distance = #(playerCoords - vector3(v.x, v.y, v.z))

            if distance < 10.0 then
                DrawMarker(Config.Dealership.Marker.Type, v.x, v.y, v.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Dealership.Marker.Size.x, Config.Dealership.Marker.Size.y, Config.Dealership.Marker.Size.z, Config.Dealership.Marker.Color.r, Config.Dealership.Marker.Color.g, Config.Dealership.Marker.Color.b, Config.Dealership.Marker.Color.a, false, true, 2, nil, nil, false)

                if distance < 1.5 then
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to open the dealership')

                    if IsControlJustReleased(0, 38) then
                        OpenDealershipMenu()
                    end
                end
            end
        end
    end
end)

function OpenDealershipMenu()
    ESX.UI.Menu.CloseAll()

    ESX.TriggerServerCallback('car_dealership:get_cars', function(cars)
        local elements = {}

        for _, v in pairs(cars) do
            table.insert(elements, {
                label = v.label .. ' - $' .. v.price,
                value = v.model,
                price = v.price
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'car_dealership', {
            title = 'Car Dealership',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            ESX.TriggerServerCallback('car_dealership:buy_car', function(success)
                if success then
                    ESX.ShowNotification('You have purchased a ' .. data.current.label)
                else
                    ESX.ShowNotification('You do not have enough money')
                end
            end, data.current.value, data.current.price)
        end, function(data, menu)
            menu.close()
        end)
    end)
end