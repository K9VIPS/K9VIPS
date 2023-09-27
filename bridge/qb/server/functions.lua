local functions = {}

function CreateQbExport(name, cb)
    AddEventHandler(string.format('__cfx_export_qb-core_%s', name), function(setCB)
        setCB(cb)
    end)
end

---@deprecated
functions.GetCoords = GetCoordsFromEntity

---@deprecated use the native GetPlayerIdentifierByType?
functions.GetIdentifier = GetPlayerIdentifierByType

---@deprecated use the native GetPlayers instead
functions.GetPlayers = GetPlayers

---@deprecated Use functions.CreateVehicle instead.
function functions.SpawnVehicle(source, model, coords, warp)
    return SpawnVehicle(source, model, coords, warp)
end

---@deprecated use SpawnVehicle from imports/utils.lua
functions.CreateVehicle = SpawnVehicle

---@deprecated No replacement. See https://overextended.dev/ox_inventory/Functions/Client#useitem
---@param source Source
---@param item string name
function functions.UseItem(source, item)
    if GetResourceState('qb-inventory') == 'missing' then return end
    exports['qb-inventory']:UseItem(source, item)
end

---@deprecated use KickWithReason from imports/utils.lua
functions.Kick = KickWithReason

---@deprecated use IsLicenseInUse from imports/utils.lua
functions.IsLicenseInUse = IsLicenseInUse

-- Utility functions

---@deprecated use https://overextended.dev/ox_inventory/Functions/Server#search
functions.HasItem = HasItem

---@deprecated use GetPlate from imports/utils.lua
functions.GetPlate = GetPlate

-- Single add item
---@deprecated incompatible with ox_inventory. Update ox_inventory item config instead.
local function AddItem(itemName, item)
    lib.print.warn(string.format("%s invoked Deprecated function AddItem. This is incompatible with ox_inventory", GetInvokingResource() or 'unknown resource'))
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end

    if QBX.Shared.Items[itemName] then
        return false, "item_exists"
    end

    QBX.Shared.Items[itemName] = item

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

functions.AddItem = AddItem
CreateQbExport('AddItem', AddItem)

-- Single update item
---@deprecated incompatible with ox_inventory. Update ox_inventory item config instead.
local function UpdateItem(itemName, item)
    lib.print.warn(string.format("%s invoked deprecated function UpdateItem. This is incompatible with ox_inventory", GetInvokingResource() or 'unknown resource'))
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end
    if not QBX.Shared.Items[itemName] then
        return false, "item_not_exists"
    end
    QBX.Shared.Items[itemName] = item
    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

functions.UpdateItem = UpdateItem
CreateQbExport('UpdateItem', UpdateItem)

-- Multiple Add Items
---@deprecated incompatible with ox_inventory. Update ox_inventory item config instead.
local function AddItems(items)
    lib.print.warn(string.format("%s invoked deprecated function AddItems. This is incompatible with ox_inventory", GetInvokingResource() or 'unknown resource'))
    local shouldContinue = true
    local message = "success"
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= "string" then
            message = "invalid_item_name"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if QBX.Shared.Items[key] then
            message = "item_exists"
            shouldContinue = false
            errorItem = items[key]
            break
        end

        QBX.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('QBCore:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, message, nil
end

functions.AddItems = AddItems
CreateQbExport('AddItems', AddItems)

-- Single Remove Item
---@deprecated incompatible with ox_inventory. Update ox_inventory item config instead.
local function RemoveItem(itemName)
    lib.print.warn(string.format("%s invoked deprecated function RemoveItem. This is incompatible with ox_inventory", GetInvokingResource() or 'unknown resource'))
    if type(itemName) ~= "string" then
        return false, "invalid_item_name"
    end

    if not QBX.Shared.Items[itemName] then
        return false, "item_not_exists"
    end

    QBX.Shared.Items[itemName] = nil

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

functions.RemoveItem = RemoveItem
CreateQbExport('RemoveItem', RemoveItem)

-- Single add job function which should only be used if you planning on adding a single job
---@deprecated use export CreateJobs
---@param jobName string
---@param job Job
---@return boolean success
---@return string message
local function AddJob(jobName, job)
    if type(jobName) ~= "string" then
        return false, "invalid_job_name"
    end

    if QBX.Shared.Jobs[jobName] then
        return false, "job_exists"
    end

    QBX.Shared.Jobs[jobName] = job

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

functions.AddJob = AddJob
CreateQbExport('AddJob', AddJob)

-- Multiple Add Jobs
---@deprecated call export CreateJobs
---@param jobs table<string, Job>
---@return boolean success
---@return string message
---@return Job? errorJob job causing the error message. Only present if success is false.
local function AddJobs(jobs)

    for key, value in pairs(jobs) do
        if type(key) ~= "string" then
            return false, 'invalid_job_name', jobs[key]
        end

        if QBX.Shared.Jobs[key] then
            return false, 'job_exists', jobs[key]
        end

        QBX.Shared.Jobs[key] = value
    end

    TriggerClientEvent('QBCore:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, 'success'
end

functions.AddJobs = AddJobs
CreateQbExport('AddJobs', AddJobs)

-- Single Update Job
---@deprecated call CreateJobs
---@param jobName string
---@param job Job
---@return boolean success
---@return string message
local function UpdateJob(jobName, job)
    if type(jobName) ~= "string" then
        return false, "invalid_job_name"
    end

    if not QBX.Shared.Jobs[jobName] then
        return false, "job_not_exists"
    end

    QBX.Shared.Jobs[jobName] = job

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

functions.UpdateJob = UpdateJob
CreateQbExport('UpdateJob', UpdateJob)

-- Single Add Gang
---@deprecated call export CreateGangs
---@param gangName string
---@param gang Gang
---@return boolean success
---@return string message
local function AddGang(gangName, gang)
    if type(gangName) ~= "string" then
        return false, "invalid_gang_name"
    end

    if QBX.Shared.Gangs[gangName] then
        return false, "gang_exists"
    end

    QBX.Shared.Gangs[gangName] = gang

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

functions.AddGang = AddGang
CreateQbExport('AddGang', AddGang)

-- Single Update Gang
---@deprecated call export CreateGangs
---@param gangName string
---@param gang Gang
---@return boolean success
---@return string message
local function UpdateGang(gangName, gang)
    if type(gangName) ~= "string" then
        return false, "invalid_gang_name"
    end

    if not QBX.Shared.Gangs[gangName] then
        return false, "gang_not_exists"
    end

    QBX.Shared.Gangs[gangName] = gang

    TriggerClientEvent('QBCore:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, "success"
end

functions.UpdateGang = UpdateGang
CreateQbExport('UpdateGang', UpdateGang)

-- Multiple Add Gangs
---@deprecated call export CreateGangs
---@param gangs table<string, Gang>
---@return boolean success
---@return string message
---@return Gang? errorGang present if success is false. Gang that caused the error message.
local function AddGangs(gangs)
    for key, value in pairs(gangs) do
        if type(key) ~= "string" then
            return false, 'invalid_gang_name', gangs[key]
        end

        if QBX.Shared.Gangs[key] then
            return false, 'gang_exists', gangs[key]
        end

        QBX.Shared.Gangs[key] = value
    end

    TriggerClientEvent('QBCore:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('QBCore:Server:UpdateObject')
    return true, 'success'
end

functions.AddGangs = AddGangs
CreateQbExport('AddGangs', AddGangs)

functions.RemoveJob = RemoveJob
CreateQbExport('RemoveJob', RemoveJob)

functions.RemoveGang = RemoveGang
CreateQbExport('RemoveGang', RemoveGang)

---Add a new function to the Functions table of the player class
---Use-case:
-- [[
--     AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
--         functions.AddPlayerMethod(Player.PlayerData.source, "functionName", function(oneArg, orMore)
--             -- do something here
--         end)
--     end)
-- ]]
---@deprecated
---@param ids number|number[] which players to add the method to. -1 for all players
---@param methodName string
---@param handler function
function functions.AddPlayerMethod(ids, methodName, handler)
    local idType = type(ids)
    if idType == "number" then
        if ids == -1 then
            for _, v in pairs(QBX.Players) do
                v.Functions.AddMethod(methodName, handler)
            end
        else
            if not QBX.Players[ids] then return end

            QBX.Players[ids].Functions.AddMethod(methodName, handler)
        end
    elseif idType == "table" and table.type(ids) == "array" then
        for i = 1, #ids do
            functions.AddPlayerMethod(ids[i], methodName, handler)
        end
    end
end

---Add a new field table of the player class
---Use-case:
--[[
    AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
        functions.AddPlayerField(Player.PlayerData.source, "fieldName", "fieldData")
    end)
]]
---@deprecated
---@param ids number|number[] which players to add a new field to. -1 for all players
---@param fieldName string
---@param data any
function functions.AddPlayerField(ids, fieldName, data)
    local idType = type(ids)
    if idType == "number" then
        if ids == -1 then
            for _, v in pairs(QBX.Players) do
                v.Functions.AddField(fieldName, data)
            end
        else
            if not QBX.Players[ids] then return end

            QBX.Players[ids].Functions.AddField(fieldName, data)
        end
    elseif idType == "table" and table.type(ids) == "array" then
        for i = 1, #ids do
            functions.AddPlayerField(ids[i], fieldName, data)
        end
    end
end

-- Add or change (a) method(s) in the Functions table
---@deprecated
---@param methodName string
---@param handler function
---@return boolean success
---@return string message
local function SetMethod(methodName, handler)
    if type(methodName) ~= "string" then
        return false, "invalid_method_name"
    end

    functions[methodName] = handler

    TriggerEvent('QBCore:Server:UpdateObject')

    return true, "success"
end

functions.SetMethod = SetMethod
CreateQbExport("SetMethod", SetMethod)

-- Add or change (a) field(s) in the QBCore table
---@deprecated
---@param fieldName string
---@param data any
---@return boolean success
---@return string message
local function SetField(fieldName, data)
    if type(fieldName) ~= "string" then
        return false, "invalid_field_name"
    end

    QBX[fieldName] = data

    TriggerEvent('QBCore:Server:UpdateObject')

    return true, "success"
end

functions.SetField = SetField
exports("SetField", SetField)

---@param identifier Identifier
---@return integer source of the player with the matching identifier or 0 if no player found
function functions.GetSource(identifier)
    return exports.qbx_core:GetSource(identifier)
end

---@param source Source|string source or identifier of the player
---@return Player
function functions.GetPlayer(source)
    return exports.qbx_core:GetPlayer(source)
end

---@param citizenid string
---@return Player?
function functions.GetPlayerByCitizenId(citizenid)
    return exports.qbx_core:GetPlayerByCitizenId(citizenid)
end

---@param citizenid string
---@return Player?
function functions.GetOfflinePlayerByCitizenId(citizenid)
    return exports.qbx_core:GetOfflinePlayerByCitizenId(citizenid)
end

---@param number string
---@return Player?
function functions.GetPlayerByPhone(number)
    return exports.qbx_core:GetPlayersByPhone(number)
end

---Will return an array of QB Player class instances
---unlike the GetPlayers() wrapper which only returns IDs
---@return table<Source, Player>
function functions.GetQBPlayers()
    return exports.qbx_core:GetQBPlayers()
end

---Gets a list of all on duty players of a specified job and the number
---@param job string name
---@return integer
---@return Source[]
function functions.GetDutyCountJob(job)
    return exports.qbx_core:GetDutyCountJob(job)
end

---Gets a list of all on duty players of a specified job type and the number
---@param type string
---@return integer
---@return Source[]
function functions.GetDutyCountType(type)
    return exports.qbx_core:GetDutyCountType(type)
end

-- Returns the objects related to buckets, first returned value is the player buckets, second one is entity buckets
---@return table
---@return table
function functions.GetBucketObjects()
    return exports.qbx_core:GetBucketObjects()
end

-- Will set the provided player id / source into the provided bucket id
---@param source Source
---@param bucket integer
---@return boolean
function functions.SetPlayerBucket(source, bucket)
    return exports.qbx_core:SetPlayerBucket(source, bucket)
end

-- Will set any entity into the provided bucket, for example peds / vehicles / props / etc.
---@param entity integer
---@param bucket integer
---@return boolean
function functions.SetEntityBucket(entity, bucket)
    return exports.qbx_core:SetEntityBucket(entity, bucket)
end

-- Will return an array of all the player ids inside the current bucket
---@param bucket integer
---@return Source[]|boolean
function functions.GetPlayersInBucket(bucket)
    return exports.qbx_core:GetPlayersInBucket(bucket)
end

-- Will return an array of all the entities inside the current bucket (not for player entities, use GetPlayersInBucket for that)
---@param bucket integer
---@return boolean | integer[]
function functions.GetEntitiesInBucket(bucket)
    return exports.qbx_core:GetEntitiesInBucket(bucket)
end

-- Items
---@param item string name
---@param data fun(source: Source, item: unknown)
function functions.CreateUseableItem(item, data)
    exports.qbx_core:CreateUseableItem(item, data)
end

---@param item string name
---@return unknown
function functions.CanUseItem(item)
    return exports.qbx_core:CanUseItem(item)
end

-- Check if player is whitelisted, kept like this for backwards compatibility or future plans
---@param source Source
---@return boolean
function functions.IsWhitelisted(source)
    return exports.qbx_core:IsWhitelisted(source)
end

---@param source Source
---@param permission string
function functions.AddPermission(source, permission)
    exports.qbx_core:AddPermission(source, permission)
end

---@param source Source
---@param permission string
function functions.RemovePermission(source, permission)
    exports.qbx_core:RemovePermission(source, permission)
end

-- Checking for Permission Level
---@param source Source
---@param permission string|string[]
---@return boolean
function functions.HasPermission(source, permission)
    return exports.qbx_core:HasPermission(source, permission)
end

---@param source Source
---@return table<string, boolean>
function functions.GetPermission(source)
    return exports.qbx_core:GetPermission(source)
end

-- Opt in or out of admin reports
---@param source Source
---@return boolean
function functions.IsOptin(source)
    return exports.qbx_core:IsOptin(source)
end

---Opt in or out of admin reports
---@param source Source
function functions.ToggleOptin(source)
    exports.qbx_core:ToggleOptin(source)
end

-- Check if player is banned
---@param source Source
---@return boolean
---@return string? playerMessage
function functions.IsPlayerBanned(source)
    return exports.qbx_core:IsPlayerBanned(source)
end

---@see client/functions.lua:functions.Notify
function functions.Notify(source, text, notifyType, duration, subTitle, notifyPosition, notifyStyle, notifyIcon, notifyIconColor)
    exports.qbx_core:Notify(source, text, notifyType, duration, subTitle, notifyPosition, notifyStyle, notifyIcon, notifyIconColor)
end

---@param InvokingResource string
---@return string version
function functions.GetCoreVersion(InvokingResource)
    return exports.qbx_core:GetCoreVersion(InvokingResource)
end