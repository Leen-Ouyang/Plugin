bag="背包"
config={
    msg={
        item="╔═══════════════╗\n            远程背包\n  ——————————\n   积分 {point}       道具 {num}\n  ——————————\n  {items}\n   指令:\n      「查看+道具名」\n       「使用+道具名」\n╚═══════════════╝"
    }
}
msg_order={}
msg_order[bag]="viewBag"

msg_order[info] = "getInformation"
player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewBag(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「创建新角色」"
    end
    --[[ local point = players[QQ]["points"]
    local items = players[QQ]["Bag"]["item"]
    local num = players[QQ]["Bag"]["sum"]
    config.msg.item = config.msg.sign_success:gsub("{point}", point)
    config.msg.item = config.msg.sign_success:gsub("{num}", num)
    config.msg.item = config.msg.sign_success:gsub("{items}", items) ]]
    return config.msg.item
end
