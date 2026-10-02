local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('car_dealership:get_cars', function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM car_dealership_cars', {}, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('car_dealership:buy_car', function(source, cb, model, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
            ['@owner'] = xPlayer.identifier,
            ['@plate'] = GeneratePlate(),
            ['@vehicle'] = json.encode({model = model, plate = GeneratePlate()})
        }, function(rowsChanged)
            cb(true)
        end)
    else
        cb(false)
    end
end)

function GeneratePlate()
    local plate = ''
    for i = 1, 8 do
        plate = plate .. string.char(math.random(65, 90))
    end
    return plate
end