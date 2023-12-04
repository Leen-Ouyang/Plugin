bag="背包"
checkitem=""
useitem=""
config={
    msg={
        item="╔═══════════════╗\n             远程背包\n  ——————————\n   积分 {point}           道具 {num}\n  ——————————\n{items}\n  ——————————\n   指令:\n      「查看道具+道具名」\n      「使用道具+道具名」\n╚═══════════════╝"
    }
}
msg_order={}
msg_order[bag]="viewBag"
player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function viewBag(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    item_information="item.json"
    item_data = getSelfData(item_information)
    items = item_data:get(nil, {})
    if(items == nil)then
        items = {}
    end
    local point = players[QQ]["points"]
    local items_id = {}
    local items_name = ""
    local num = 0
    local bag = players[QQ]["Bag"]
    config.msg.item = config.msg.item:gsub("{point}", point)
    for k,v in pairs(bag) do
        table.insert(items_id,k)
        local item_count=v["count"]
        num=num+item_count
    end
    config.msg.item = config.msg.item:gsub("{num}", num)
    for i=1,#items_id do
        local id=items_id[i]
        local name=""
        for k,v in pairs(items) do
            for key,val in pairs(v) do
                if(key==id) then
                    name=val["name"]
                    break
                end
            end
            if(name~="") then
                break
            end
        end
        if (i==#items_id) then
            items_name=items_name.."  "..name
        else
            items_name=items_name.."  "..name.."\n"
        end
    end
    config.msg.item = config.msg.item:gsub("{items}", items_name)
    return config.msg.item
end
