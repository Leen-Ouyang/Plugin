shop = "商店"
pshop = "积分商店"
ashop = "成就商店"
--sshop = "特殊商店"
buyitem = "购买道具"
config = {
    msg = {
        shopmenu="╔══════════════╗\n            远程商店\n  —————————\n   指令：\n        「积分商店」\n        「成就商店」\n╚══════════════╝",
        pointshopmenu="╔                                 ╗\n            积分商店\n╚                                 ╝\n推荐商品：\n",
        achishopmenu="╔                                 ╗\n            成就商店\n╚                                 ╝\n",
        nofound="您输入的道具不存在，请重新输入",
        buypreerror="未满足购买条件",
        counterror="该道具已售罄",
        priceerror="积分不足",
        buysuccess="购买成功！"
    }
}
msg_order = {}
msg_order[shop] = "Shopmenu"
msg_order[pshop] = "Pointshop"
msg_order[ashop] = "Achievementshop"
msg_order[buyitem] = "buyItem"
--msg_order[sshop] = "Specialshop"

function Shopmenu(msg)
    return config.msg.shopmenu
end

function Pointshop(msg)
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
    local player_bag=players[QQ]["Bag"]
    shop_information="shop.json"
    shop_data = getSelfData(shop_information)
    shops = shop_data:get(nil, {})
    if(shops == nil)then
        shops = {}
    end
    item_information="item.json"
    item_data = getSelfData(item_information)
    items = item_data:get(nil, {})
    if(items == nil)then
        items = {}
    end
    local point_item = shops["Common"]
    local point_item_id = {}
    local point_item_name = {}
    local point_item_price = {}
    local point_item_description = {}
    local point_item_count = {}
    local point_item_pre = {}
    for key,value in pairs(point_item) do
        local point_item_pre=value["pre"]
        local pre_flag=1
        if(point_item_pre~=nil) then
            for k,v in pairs(point_item_pre) do
                if(k=="weather") then
                    temp="temp.json"
                    temp_data = getSelfData(temp)
                    temps = temp_data:get(nil,{})
                    if(temps == nil)then
                        temps = {}
                    end
                    local weather=""
                    for x,y in pairs(temps) do
                        if(x=="weather") then
                            weather=y
                        end
                    end
                    local weather_flag=0
                    for i=1,#v do
                        if(v[i]==weather) then
                            weather_flag=1
                            break
                        end
                    end
                    if(weather_flag==0) then
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
                elseif(k=="petting_dog" or k=="petting_cat") then
                    player_information="player.json"
                    data = getSelfData(player_information)
                    players = data:get(nil, {})
                    if(players == nil)then
                        players = {}
                    end
                    if(players[QQ]["Count"][k]<v) then
                        pre_flag=0
                        break
                    end
                end
            end
        end
        if (pre_flag==1) then
            local count=value["count"]
            if(count>0) then
                table.insert(point_item_id,key)
                table.insert(point_item_count,count)
            end
        end
    end
    for i=1,#point_item_id do
        local id=point_item_id[i]
        for k,v in pairs(items) do
            for itemid,iteminfo in pairs(v) do
                if (itemid==id) then
                    local name = iteminfo["name"]
                    local price = iteminfo["price"]
                    local description = iteminfo["description"]
                    table.insert(point_item_name,name)
                    table.insert(point_item_price,price)
                    table.insert(point_item_description,description)
                    break
                end   
            end
        end
    end
    local item_info=""
    local shoptips=""
    local item_num=10
    if(#point_item_id<10) then
        item_num=#point_item_id
    end
    if(item_num>0) then
        for i=1,item_num do
            item_info=item_info.."\n「"..point_item_name[i].."」        数量："..point_item_count[i].."    价格："..point_item_price[i].."\n      "..point_item_description[i].."\n"
        end
        shoptips="\ntips:1.输入「购买道具+道具名」指令购买道具\n       2.积分商店部分商品限购数量为全服限购数量，其他商品限购数量每日刷新"
    else
        item_info="未解锁商品"
    end
    return config.msg.pointshopmenu..item_info..shoptips
end

function Achievementshop(msg)
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
    local player_achi=players[QQ]["Achievement"]
    local player_bag=players[QQ]["Bag"]
    shop_information="shop.json"
    shop_data = getSelfData(shop_information)
    shops = shop_data:get(nil, {})
    if(shops == nil)then
        shops = {}
    end
    item_information="item.json"
    item_data = getSelfData(item_information)
    items = item_data:get(nil, {})
    if(items == nil)then
        items = {}
    end
    local achi_item = shops["Achi"]
    local achi_item_id = {}
    local achi_item_name = {}
    local achi_item_price = {}
    local achi_item_description = {}
    local achi_item_count = {}
    local achi_item_pre = {}
    for key,value in pairs(achi_item) do
        local achi_item_pre=value["pre"]
        local pre_flag=1
        for k,v in pairs(achi_item_pre) do
            for i=1,#v do
                local flag=0
                for j=1,#player_achi do
                    if(v[i]==player_achi[j]) then
                        flag=1
                        break
                    end
                end
                if(flag==0) then 
                    pre_flag=0
                    break
                end
            end
        end
        if (pre_flag==1) then
            local count=value["count"]
            local player_count=0
            for k,v in pairs(player_bag) do
                if(k==key) then
                    player_count=v["count"]
                    break
                end
            end
            if(player_count==0) then
                table.insert(achi_item_id,key)
                table.insert(achi_item_count,count)
            else
                if(player_count<count) then
                    table.insert(achi_item_id,key)
                    table.insert(achi_item_count,count-player_count)
                end
            end
        end
    end
    for i=1,#achi_item_id do
        local id=achi_item_id[i]
        for k,v in pairs(items) do
            for itemid,iteminfo in pairs(v) do
                if (itemid==id) then
                    local name = iteminfo["name"]
                    local price = iteminfo["price"]
                    local description = iteminfo["description"]
                    table.insert(achi_item_name,name)
                    table.insert(achi_item_price,price)
                    table.insert(achi_item_description,description)
                    break
                end   
            end
        end
    end
    local item_info=""
    local shoporder=""
    if(#achi_item_id>0) then 
        for i=1,#achi_item_id do
            item_info=item_info.."\n「"..achi_item_name[i].."」        数量："..achi_item_count[i].."    价格："..achi_item_price[i].."\n      "..achi_item_description[i].."\n"
        end
        shoporder="\ntips:输入「购买道具+道具名」指令购买道具"
    else
        item_info="未解锁商品"
    end
    return config.msg.achishopmenu..item_info..shoporder
end

function buyItem(msg)
    local QQ=tostring(msg.fromQQ)
    local item_name = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#buyitem+1)
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
    local player_bag=players[QQ]["Bag"]
    local point = players[QQ]["points"]
    item_information="item.json"
    item_data = getSelfData(item_information)
    items = item_data:get(nil, {})
    if(items == nil)then
        items = {}
    end
    local found_flag=0
    local id=""
    local pre={}
    local count=0
    local maxusage=0
    local unique=0
    local price=0
    local shopname=""
    local found_flag=0
    for k,v in pairs(items) do
        for key,val in pairs(v) do
            if(val["name"]==item_name) then
                id=key
                maxusage=val["max_usage"]
                shopname=val["shop"]
                unique=val["unique"]
                price=val["price"]
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
    shop_information="shop.json"
    shop_data = getSelfData(shop_information)
    shops = shop_data:get(nil, {})
    if(shops == nil)then
        shops = {}
    end
    for k,v in pairs(shops) do
        for key,val in pairs(v) do
            if(key==id) then
                pre=val["pre"]
                count=val["count"]
            end
        end
    end
    local pre_flag=1
    if(pre~=nil) then
        for k,v in pairs(pre) do
            if(k=="weather") then
                temp="temp.json"
                temp_data = getSelfData(temp)
                temps = temp_data:get(nil,{})
                if(temps == nil)then
                    temps = {}
                end
                local weather=""
                for x,y in pairs(temps) do
                    if(x=="weather") then
                        weather=y
                    end
                end
                local weather_flag=0
                for i=1,#v do
                    if(v[i]==weather) then
                        weather_flag=1
                        break
                    end
                end
                if(weather_flag==0) then
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
            elseif(k=="petting_dog" or k=="petting_cat") then
                player_information="player.json"
                data = getSelfData(player_information)
                players = data:get(nil, {})
                if(players == nil)then
                    players = {}
                end
                if(players[QQ]["Count"][k]<v) then
                    pre_flag=0
                    break
                end
            elseif(k=="semester") then
                player_information="player.json"
                data = getSelfData(player_information)
                players = data:get(nil, {})
                if(players == nil)then
                    players = {}
                end
                if(players[QQ]["Mainline"]["Semester"]~=val) then
                    pre_flag=0
                    break
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
            elseif(k=="achi") then
                player_information="player.json"
                data = getSelfData(player_information)
                players = data:get(nil, {})
                if(players == nil)then
                    players = {}
                end
                local player_achi=players[QQ]["Achievement"]
                for i=1,#v do
                    local flag=0
                    for j=1,#player_achi do
                        if(v[i]==player_achi[j]) then
                            flag=1
                            break
                        end
                    end
                    if(flag==0) then 
                        pre_flag=0
                        break
                    end
                end
            end
        end
    end
    if(pre_flag==0) then
        return config.msg.buypreerror
    end
    if(shopname=="积分商店") then
        if(unique==1) then
            if(count==0) then
                return config.msg.counterror
            else
                shop_information="shop.json"
                shop_data = getSelfData(shop_information)
                shops = shop_data:get(nil, {})
                if(shops == nil)then
                    shops = {}
                end
                if(count-1==0) then
                    shops["Common"][id]["unique"]=0
                end
                shops["Common"][id]["count"]=shops["Common"][id]["count"]-1
                shop_data:set(shops)
            end
        elseif(unique==0) then
            return config.msg.counterror
        else
            shop_information="shop.json"
            shop_data = getSelfData(shop_information)
            shops = shop_data:get(nil, {})
            if(shops == nil)then
                shops = {}
            end
            shops["Common"][id]["count"]=shops["Common"][id]["count"]-1
            shop_data:set(shops)
        end
    else
        local player_count=0
        for k,v in pairs(player_bag) do
            if(k==id) then
                player_count=v["count"]
                break
            end
        end
        if(player_count>=count) then
            return config.msg.counterror
        end
    end
    if(point<price) then
        return config.msg.priceerror
    else
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[QQ]["points"]=players[QQ]["points"]-price
        data:set(players)
    end
    local owned_flag=0
    for k,v in pairs(player_bag) do
        if(k==id) then
            owned_flag=1
            break
        end
    end
    if(owned_flag==1) then
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[QQ]["Bag"][id]["count"]=players[QQ]["Bag"][id]["count"]+1
        players[QQ]["Bag"][id]["remaining_usage"]=players[QQ]["Bag"][id]["remaining_usage"]+maxusage
        data:set(players)
    else
        local info={
            remaining_usage = maxusage,
            count = 1
        }
        player_information="player.json"
        data = getSelfData(player_information)
        players = data:get(nil, {})
        if(players == nil)then
            players = {}
        end
        players[QQ]["Bag"][id]=info
        data:set(players)
    end
    return config.msg.buysuccess
end

--[[ function Specialshop(msg)
    shop_information="shop.json"
    shop_data = getSelfData(shop_information)
    shops = shop_data:get(nil, {})
    if(shops == nil)then
        shops = {}
    end
    item_information="item.json"
    item_data = getSelfData(item_information)
    items = item_data:get(nil, {})
    if(items == nil)then
        items = {}
    end
    local spec_item = shops["Spec"]
    local spec_item_id = {}
    local spec_item_name = {}
    local spec_item_price = {}
    local spec_item_description = {}
    local spec_item_count = {}
    local spec_item_pre = {}
    local flag = 0
    for key,value in pairs(spec_item) do
        local pre=value["pre"]
        local pre_flag=1
        for k,v in pairs(pre) do
            if(key=="PoiliticsCounter") then
            elseif(key=="INT") then
            elseif(key=="MeetJasonCounter") then
            elseif(key=="AnimaCounter") then
            elseif(key=="event") then
            elseif(key=="FailtoSleepCounter") then
            elseif(key=="item") then
            elseif(key=="count")
            end
        end
        local count=value["count"]
        table.insert(spec_item_id,key)
        table.insert(spec_item_count,count)
        for k,v in pairs(items) do
            for itemid,iteminfo in pairs(v) do
                if (itemid==id) then
                    local name = iteminfo["name"]
                    local price = iteminfo["price"]
                    local description = iteminfo["description"]
                    table.insert(spec_item_name,name)
                    table.insert(spec_item_price,price)
                    table.insert(spec_item_description,description)
                    break
                end   
            end
        end
    end
    return config.msg.shopmenu
end ]]