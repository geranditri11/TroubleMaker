if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = 'https://raw.githubusercontent.com/geranditri11/TroubleMaker/refs/heads/main/Games/'

local games = {
    [15308782509] = 'Soccer-Training.lua',
    [81335362752013] = 'Throw-A-Coin.lua',
}   

local file = games[game.PlaceId]

if file then
    task.wait(math.random())
    
    local success, err = pcall(function()
        loadstring(game:HttpGet(BASE .. file))()
    end)
    
    if not success then
        warn("Script Not Loaded !!!: " .. tostring(err))
    else
        print("Script Loaded !!!: " .. file)
    end
else
    warn("Script Not Found (PlaceId: " .. tostring(game.PlaceId) .. ")")
end
