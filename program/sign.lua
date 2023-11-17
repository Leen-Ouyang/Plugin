s="签到"
config={
    msg={
        sign_success="签到成功！积分+{point}\n连续签到{days}天",
        already="今日已签到！"
    }
}
msg_order={}
msg_order[s]="sign"

function sign(msg)
    local QQ=tostring(msg.fromQQ)
    
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end

    temp="temp.json"
    temp_data = getSelfData(temp)
    temps = temp_data:get(nil,{})
    if(temps == nil)then
        temps = {}
    end
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「请先创建角色」"
    end
    if (#temps[QQ]["last_sign"]==0) then
        local last_sign=temps[QQ]["last_sign"]
        local last_year = temps[QQ]["last_sign"]["year"]
        local last_month = temps[QQ]["last_sign"]["month"]
        local last_day = temps[QQ]["last_sign"]["day"]
        local time = os.date("*t")
        local year = time.year
        local month = time.month
        local day = time.day
        if (year == last_year and month == last_month and day == last_day) then
            return config.msg.already
        else
            temps[QQ]["last_sign"]=time
            temp_data:set(temps)
            players[QQ]["Count"]["sign"]=players[QQ]["Count"]["sign"]+1
            local days=players[QQ]["Count"]["sign"]
            local point = 10+math.random(1, 10)
            players[QQ]["points"]=players[QQ]["points"]+ point
            data:set(players)
            config.msg.sign_success = config.msg.sign_success:gsub("{point}", point)
            config.msg.sign_success = config.msg.sign_success:gsub("{days}", days)
            return config.msg.sign_success
        end
    else
        local time = os.date("*t")
        local year = time.year
        local month = time.month
        local day = time.day
        temps[QQ]["last_sign"]=time
        temp_data:set(temps)
        players[QQ]["Count"]["sign"]=players[QQ]["Count"]["sign"]+1
        local days=players[QQ]["Count"]["sign"]
        local point = 10+math.random(1, 10)
        players[QQ]["points"]=players[QQ]["points"]+ point
        data:set(players)
        config.msg.sign_success = config.msg.sign_success:gsub("{point}", point)
        config.msg.sign_success = config.msg.sign_success:gsub("{days}", days)
        return config.msg.sign_success
    end
end