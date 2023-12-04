viewbag="背包"
checkitem="查看道具"
useitem="使用道具"
config={
    msg={
        item="╔═══════════════════════╗\n                       远程背包\n  ———————————————\n   积分 {point}                         道具 {num}\n  ———————————————\n{items}\n  ———————————————\n   指令:\n      「查看道具+道具名」\n      「使用道具+道具名」\n╚═══════════════════════╝",
        nofound="您输入的道具不存在，请重新输入",
        noowned="您未拥有该道具！",
        usesuccess="使用道具「{name}」成功！",
        preerror="未满足使用条件，无法使用"
    }
}
msg_order={}
msg_order[viewbag]="viewBag"
msg_order[checkitem]="viewItem"
msg_order[useitem]="UseItem"

function viewBag(msg)
    local QQ=tostring(msg.fromQQ)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
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
    local count = {}
    local bag = players[QQ]["Bag"]
    config.msg.item = config.msg.item:gsub("{point}", point)
    for k,v in pairs(bag) do
        table.insert(items_id,k)
        table.insert(count,v["count"])
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
            items_name=items_name.."  "..name.." x"..count[i]
        else
            items_name=items_name.."  "..name.." x"..count[i].."\n"
        end
    end
    config.msg.item = config.msg.item:gsub("{items}", items_name)
    return config.msg.item
end

function viewItem(msg)
    local QQ=tostring(msg.fromQQ)
    local item_name = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#checkitem+1)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
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
    local found_flag=0
    local id=""
    local description=""
    for k,v in pairs(items) do
        for key,val in pairs(v) do
            if(val["name"]==item_name) then
                if(players[QQ]["Bag"][k]["count"]=0) then
                    break
                end
                id=key
                description=val["description"]
                found_flag=1
                break
            end
        end
        if(found_flag==1) then
            break
        end
    end
    if(found_flag==0) then
        return config.msg.nofound
    end
    local bag = players[QQ]["Bag"]
    local owned_flag=0
    local count=0
    for k,v in pairs(bag) do
        if(k==id) then
            count=v["count"]
            owned_flag=1
            break
        end
    end
    if(owned_flag==0) then
        return config.msg.noowned
    end
    return "「"..item_name.."」".."           数量："..count.."\n"..description
end

function UseItem(msg)
    local QQ=tostring(msg.fromQQ)
    local item_name = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#checkitem+1)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
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
    local found_flag=0
    local id=""
    local buff={}
    local pre={}
    for k,v in pairs(items) do
        for key,val in pairs(v) do
            if(val["name"]==item_name) then
                id=key
                buff=val["buff"]
                pre=val["pre"]
                found_flag=1
                break
            end
        end
        if(found_flag==1) then
            break
        end
    end
    if(found_flag==0) then
        return config.msg.nofound
    end
    local bag = players[QQ]["Bag"]
    local owned_flag=0
    local count=0
    for k,v in pairs(bag) do
        if(k==id) then
            if(players[QQ]["Bag"][k]["count"]=0) then
                break
            end
            players[QQ]["Bag"][k]["count"]=players[QQ]["Bag"][k]["count"]-1
            players[QQ]["Bag"][k]["remaining_usage"]=players[QQ]["Bag"][k]["remaining_usage"]-1
            owned_flag=1
            break
        end
    end
    if(owned_flag==0) then
        return config.msg.noowned
    end

    return config.msg.usesuccess
end
