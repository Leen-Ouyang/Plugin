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
    local maxusage=0
    local buff={}
    local eternal=false
    for k,v in pairs(items) do
        for key,val in pairs(v) do
            if(val["name"]==item_name) then
                id=key
                description=val["description"]
                maxusage=val["max_usage"]
                buff=val["buff"]
                eternal=val["eternal"]
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
    local remaind
    for k,v in pairs(bag) do
        if(k==id) then
            if(v["count"]==0) then
                break
            end
            count=v["count"]
            if(v["remaining_usage"]>0) then
                remaind=v["remaining_usage"]
            else
                remaind="∞"
            end
            owned_flag=1
            break
        end
    end
    if(owned_flag==0) then
        return config.msg.noowned
    end
    local buff_info=""
    local buff_num=0
    for k,v in pairs(buff) do
        buff_num=buff_num+1
    end
    local temporary=""
    local odds_info=""
    if(buff_num>0) then
        buff_info="\n加成："
        local temporary_flag=0
        local odds_flag=0
        for k,v in pairs(buff) do
            if(k=="INT") then
                buff_info=buff_info.."\n        智力+"..v
            elseif(k=="CON") then
                buff_info=buff_info.."\n        体质+"..v
            elseif(k=="LUC") then
                buff_info=buff_info.."\n        运气+"..v
            elseif(k=="WIL") then
                buff_info=buff_info.."\n        意志+"..v
            elseif(k=="mood") then
                if(eternal==true) then
                    buff_info=buff_info.."\n        心情上限+"..v
                else
                    buff_info=buff_info.."\n        心情+"..v
                end
            elseif(k=="energy") then
                if(eternal==true) then
                    buff_info=buff_info.."\n        精力上限+"..v
                else
                    buff_info=buff_info.."\n        精力+"..v
                end
            elseif(k=="discount") then
                buff_info=buff_info.."\n        商品打折"
            elseif(k=="odds" or k=="result") then
                buff_info=buff_info.."\n        提升事件成功概率"
                odds_flag=1
            elseif(k=="label" or k=="event" or k=="title" or k=="ending") then
                temporary_flag=1
            elseif(k=="random_item") then
                buff_info=""
            end               
        end
        if(temporary_flag==1) then
            temporary="，仅对特定事件加成"
        end
        if(odds_flag==1) then
            odds_info="，所有提升概率的道具效果不叠加"
        end
    end
    if(maxusage>0) then
        return "「"..item_name.."」".."           数量："..count.."      总剩余使用次数："..remaind.."\n"..description..buff_info.."\nps:该道具每个能使用"..maxusage.."次"..temporary..odds_info
    else
        return "「"..item_name.."」".."           数量："..count.."      总剩余使用次数："..remaind.."\n"..description..buff_info.."\nps:该道具每个能使用无限次"..temporary..odds_info
    end
end

function UseItem(msg)
    local QQ=tostring(msg.fromQQ)
    local item_name = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#checkitem+1)
    local rand_info=""
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
    local maxusage=0
    local eternal=false
    for k,v in pairs(items) do
        for key,val in pairs(v) do
            if(val["name"]==item_name) then
                id=key
                buff=val["buff"]
                pre=val["pre"]
                maxusage=val["max_usage"]
                eternal=val["eternal"]
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
    local buff_num=0
    for k,v in pairs(buff) do
        buff_num=buff_num+1
    end
    local bag = players[QQ]["Bag"]
    local owned_flag=0
    local count=0
    local remaind=0
    local buff_att={}
    local buff_val={}
    for k,v in pairs(bag) do
        if(k==id) then
            if(v["count"]==0) then
                break
            end
            for key,val in pairs(buff) do
                table.insert(buff_att,key)
                table.insert(buff_val,val)
            end
            owned_flag=1
            break
        end
    end
    if(owned_flag==0) then
        return config.msg.noowned
    end
    local pre_num=0
    for k,v in pairs(pre) do
        pre_num=pre_num+1
    end
    local pre_flag=1
    if(pre_num>0) then
        for k,v in pairs(pre) do
            if(k=="semester") then
                player_information="player.json"
                data = getSelfData(player_information)
                players = data:get(nil, {})
                if(players == nil)then
                    players = {}
                end
                if(players[QQ]["Mainline"]~=val) then
                    pre_flag=0
                    break
                end
            elseif(k=="wday") then
                local time=os.date("*t")
                local wday=time.wday
                if (wday==1) then
                    wday=8
                end
                wday=wday-1
                if(wday~=v) then
                    pre_flag=0
                    break
                end
            elseif(k=="weather") then
                temp="temp.json"
                temp_data = getSelfData(temp)
                temps = temp_data:get(nil,{})
                if(temps == nil)then
                    temps = {}
                end
                for key,val in pairs(temps) do
                    if(key=="weather") then
                        if(val~=v) then
                            pre_flag=0
                            break
                        end
                    end
                end
            elseif(k=="energy" or k=="mood") then
                player_information="player.json"
                data = getSelfData(player_information)
                players = data:get(nil, {})
                if(players == nil)then
                    players = {}
                end
                if (players[QQ]["DailyAtt"][k]<v) then
                    pre_flag=0
                    break
                end
            elseif(k=="LUC" or k=="CON" or k=="INT" or k=="WIL") then
                player_information="player.json"
                data = getSelfData(player_information)
                players = data:get(nil, {})
                if(players == nil)then
                    players = {}
                end
                if (players[QQ]["Mainline"][k]<v) then
                    pre_flag=0
                    break
                end
            end
        end
    end
    if(pre_flag==0) then
        return config.msg.preerror
    end
    if (eternal==true) then
        if(buff_num>0) then
            local discount=0
            local category={}
            local odds=0
            local events={}
            for i=1,#buff_att do
                local buff_name=buff_att[i]
                local buff_value=buff_val[i]
                if(buff_name=="INT" or buff_name=="CON" or buff_name=="LUC" or buff_name=="WIL") then
                    player_information="player.json"
                    data = getSelfData(player_information)
                    players = data:get(nil, {})
                    if(players == nil)then
                        players = {}
                    end
                    players[QQ]["MainAtt"][buff_name]=players[QQ]["MainAtt"][buff_name]+buff_value
                    players[QQ]["MainAtt"]["SUM"]=players[QQ]["MainAtt"]["SUM"]+buff_value
                    data:set(players)
                elseif(buff_name=="mood" or buff_name=="energy") then
                    player_information="player.json"
                    data = getSelfData(player_information)
                    players = data:get(nil, {})
                    if(players == nil)then
                        players = {}
                    end
                    local limit=buff_name.."_limit"
                    players[QQ]["DailyAtt"][buff_name]=players[QQ]["DailyAtt"][buff_name]+buff_value
                    players[QQ]["DailyAtt"][limit]=players[QQ]["DailyAtt"][limit]+buff_value
                    data:set(players)
                elseif(buff_name=="discount") then
                    discount=buff_value
                elseif(buff_name=="result" or buff_name=="odds") then
                    odds=buff_value
                elseif(buff_name=="event" or buff_name=="label") then
                    events=buff_value
                elseif(buff_name=="category") then
                    category=buff_value
                end
            end
            if(discount>0) then
                for i=1,#category do
                    local ctg=category[i]
                    temp="temp.json"
                    temp_data = getSelfData(temp)
                    temps = temp_data:get(nil,{})
                    if(temps == nil)then
                        temps = {}
                    end
                    temps[QQ]["discount"][ctg]=temps[QQ]["discount"][ctg]*discount
                    temp_data:set(temps)
                end
            end
            if(odds>0) then
                for i=1,#events do
                    local e=events[i]
                    temp="temp.json"
                    temp_data = getSelfData(temp)
                    temps = temp_data:get(nil,{})
                    if(temps == nil)then
                        temps = {}
                    end
                    temps[QQ]["odds"][e]=odds
                    temp_data:set(temps)
                end
            end
        end
    else
        if(buff_num>0) then
            temp="temp.json"
            temp_data = getSelfData(temp)
            temps = temp_data:get(nil,{})
            if(temps == nil)then
                temps = {}
            end
            local player_buff=temps[QQ]["buff"]
            local used_flag=0
            for key,val in pairs(player_buff) do
                if(key==id) then
                    used_flag=1
                    break
                end
            end
            local random_item=0
            local category={}
            for key,val in pairs(buff) do
                if(key=="energy" or key=="mood") then
                    player_information="player.json"
                    data = getSelfData(player_information)
                    players = data:get(nil, {})
                    if(players == nil)then
                        players = {}
                    end
                    players[QQ]["DailyAtt"][key]=players[QQ]["DailyAtt"][key]+val
                    data:set(players)
                    buff[key]=nil
                elseif(key=="category") then
                    category=val
                elseif(key=="random_item") then
                    random_item=val
                end
            end
            if(random_item>0) then
                buff=nil
                local itemid_list={}
                item_information="item.json"
                item_data = getSelfData(item_information)
                items = item_data:get(nil, {})
                if(items == nil)then
                    items = {}
                end
                for i=1,#category do
                    local ctgitems=items[category[i]]
                    for key,val in pairs(ctgitems) do
                        if (val["shop"]=="积分商店") then
                            shop_information="shop.json"
                            shop_data = getSelfData(shop_information)
                            shops = shop_data:get(nil, {})
                            if(shops == nil)then
                                shops = {}
                            end
                            local item_pre=shops["Common"][key]["pre"]
                            local prenum=0
                            for prename,preval in pairs(item_pre) do
                                prenum=prenum+1
                            end
                            local itempre_flag=1
                            if(prenum>0) then
                                for prename,preval in pairs(item_pre) do
                                    if(prename=="weather") then
                                        temp="temp.json"
                                        temp_data = getSelfData(temp)
                                        temps = temp_data:get(nil,{})
                                        if(temps == nil)then
                                            temps = {}
                                        end
                                        for x,y in pairs(temps) do
                                            if(x=="weather") then
                                                if(preval~=y) then
                                                    itempre_flag=0
                                                    break
                                                end
                                            end
                                        end
                                    elseif(prename=="CatCounter") then
                                        player_information="player.json"
                                        data = getSelfData(player_information)
                                        players = data:get(nil, {})
                                        if(players == nil)then
                                            players = {}
                                        end
                                        if(players[QQ]["Count"]["CatCounter"]<preval) then
                                            itempre_flag=0
                                            break
                                        end
                                    end
                                end
                            end
                            if(itempre_flag==1) then
                                table.insert(itemid_list,key)
                            end
                        end
                    end
                end
                local item_list={}
                for j=1,random_item do
                    local rand_number=math.random(1, #itemid_list)
                    table.insert(item_list,itemid_list[rand_number])
                end
                local rand_name=""
                for j=1,#item_list do
                    item_information="item.json"
                    item_data = getSelfData(item_information)
                    items = item_data:get(nil, {})
                    if(items == nil)then
                        items = {}
                    end
                    for key,val in pairs(items) do
                        for x,y in pairs(val) do
                            if(x==item_list[i]) then
                                if(i==#item_list) then
                                    rand_name=rand_name..y["name"]
                                else
                                    rand_name=rand_name..y["name"].."、"
                                end
                                local rem=y["max_usage"]
                                local info={
                                    remaining_usage = rem,
                                    count = 1
                                }
                                player_information="player.json"
                                data = getSelfData(player_information)
                                players = data:get(nil, {})
                                if(players == nil)then
                                    players = {}
                                end
                                players[QQ]["Bag"][x]=info
                                data:set(players)
                                break
                            end 
                        end
                    end
                end
                rand_info="恭喜获得道具"..rand_name                   
            end
            buff_num=0
            if(buff) then
                for k,v in pairs(buff) do
                    buff_num=buff_num+1
                end
            end
            if(buff_num>0) then
                if(used_flag==0) then
                    temps[QQ]["buff"][id]=buff
                    temp_data:set(temps)
                else
                    for k,v in pairs(buff) do
                        if(k=="INT" or k=="CON" or k=="LUC" or k=="WIL") then
                            temps[QQ]["buff"][id][k]=temps[QQ]["buff"][id][k]+v
                            temp_data:set(temps)
                        elseif(k=="discount") then
                            temps[QQ]["buff"][id][k]=temps[QQ]["buff"][id][k]*v
                            temp_data:set(temps)
                        end
                    end
                end
            end
        end
    end
    if(maxusage>0) then
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[QQ]["Bag"][id]["remaining_usage"]=players[QQ]["Bag"][id]["remaining_usage"]-1
        remaind=players[QQ]["Bag"][id]["remaining_usage"]
        players[QQ]["Bag"][id]["count"]=math.ceil(remaind/maxusage)
        data:set(players)
    end
    config.msg.usesuccess = config.msg.usesuccess:gsub("{name}", item_name)
    return config.msg.usesuccess..rand_info
end