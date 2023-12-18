s="签到"
config={
    msg={
        sign_success="签到成功！积分+{point}\n累计签到{days}天",
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
    if (#temps[QQ]["last_sign"]~={}) then
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
            players[QQ]["Count"]["sign"]=players[QQ]["Count"]["sign"]+1
            local days=players[QQ]["Count"]["sign"]
            local point = 10+math.random(1, 10)
            local achi_msg=""
            players[QQ]["points"]=players[QQ]["points"]+ point
            if (days==3) then
                local ach=players[QQ]["Achievement"]
                table.insert(ach,"ac001")
                players[QQ]["Achievement"]=ach
                players[QQ]["points"]=players[QQ]["points"]+30
                achi_msg="\n恭喜！解锁成就「小苗初成」"
            elseif (days==7) then
                local ach=players[QQ]["Achievement"]
                table.insert(ach,"ac002")
                players[QQ]["Achievement"]=ach
                players[QQ]["MainAtt"]["WIL"]=players[QQ]["MainAtt"]["WIL"]+1
                players[QQ]["MainAtt"]["SUM"]=players[QQ]["MainAtt"]["SUM"]+1
                achi_msg="\n恭喜！解锁成就「枝繁叶茂」"
            elseif (days==30) then
                local ach=players[QQ]["Achievement"]
                table.insert(ach,"ac003")
                players[QQ]["Achievement"]=ach
                players[QQ]["MainAtt"]["WIL"]=players[QQ]["MainAtt"]["WIL"]+2
                players[QQ]["MainAtt"]["SUM"]=players[QQ]["MainAtt"]["SUM"]+2
                achi_msg="\n恭喜！解锁成就「开花结果」"    
            end
            data:set(players)
            temp_data:set(temps)
            config.msg.sign_success = config.msg.sign_success:gsub("{point}", point)
            config.msg.sign_success = config.msg.sign_success:gsub("{days}", days)
            return config.msg.sign_success..achi_msg
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