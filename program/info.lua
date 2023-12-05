info = "档案"
config = {
    msg = {
        record="╔═══════════════╗\n            个人档案\n  姓名  {name}\n  性别 {gender}      职业 {job}\n  个人简介\n  {intro}\n  ——————————\n   主属性        每日状态\n  智力  {int}         精力\n  体质 {con}        {energy}/{energy_limit}\n  意志 {wil}         心情\n  运气 {luc}       {mood}/{mood_limit}\n  ——————————\n  学年  {semester}         学分 {credit}\n  积分  {point}       成就数 {achi_num}\n{buff}╚═══════════════╝\n"
    }
}
msg_order = {}
msg_order[info] = "getInformation"
player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end

function getInformation(msg)
    local QQ=tostring(msg.fromQQ)
    if (players[QQ]) then
        if (players[QQ]["Info"]["Nickname"]==nil) then 
            return "未创建角色，请先创建角色「创建新角色」"
        end
    else
        return "未创建角色，请先创建角色「创建新角色」"
    end
    local name = players[QQ]["Info"]["Nickname"]
    local gender = players[QQ]["Info"]["Gender"]
    local job = players[QQ]["Info"]["Job"]
    local intro = players[QQ]["Info"]["Introduction"]
    local int = players[QQ]["MainAtt"]["INT"]
    int = string.format("%2d",int)
    local con = players[QQ]["MainAtt"]["CON"]
    con = string.format("%2d",con)
    local wil = players[QQ]["MainAtt"]["WIL"]
    wil = string.format("%2d",wil)
    local luc = players[QQ]["MainAtt"]["LUC"]
    luc = string.format("%2d",luc)
    local energy_limit = players[QQ]["DailyAtt"]["energy_limit"]
    local energy = players[QQ]["DailyAtt"]["energy"]
    local mood_limit = players[QQ]["DailyAtt"]["mood_limit"]
    local mood = players[QQ]["DailyAtt"]["mood"]
    local semester = players[QQ]["Mainline"]["Semester"]
    local credit = players[QQ]["Mainline"]["credit"]
    local point = players[QQ]["points"]
    local achi_num = #players[QQ]["Achievement"]
    local buff=""
    temp="temp.json"
    temp_data = getSelfData(temp)
    temps = temp_data:get(nil,{})
    if(temps == nil)then
        temps = {}
    end
    local item_buff=temps[QQ]["buff"]
    local buffnum=0
    for k,v in pairs(item_buff) do
        buffnum=buffnum+1
    end
    if (buffnum>0) then
        local first_flag=0
        for k,v in pairs(item_buff) do
            if(k=="INT") then
                if(first_flag==0) then
                    buff=buff.."  ——————————\n  道具加成：\n"
                    first_flag=1
                end
                buff=buff.."      智力+"..v.."\n"
            elseif(k=="CON") then
                if(first_flag==0) then
                    buff=buff.."  ——————————\n  道具加成：\n"
                    first_flag=1
                end
                buff=buff.."      体质+"..v.."\n"
            elseif(k=="LUC") then
                if(first_flag==0) then
                    buff=buff.."  ——————————\n  道具加成：\n"
                    first_flag=1
                end
                buff=buff.."      运气+"..v.."\n"
            elseif(k=="WIL") then
                if(first_flag==0) then
                    buff=buff.."  ——————————\n  道具加成：\n"
                    first_flag=1
                end
                buff=buff.."      意志+"..v.."\n"
            elseif(k=="mood") then
                if(first_flag==0) then
                    buff=buff.."  ——————————\n  道具加成：\n"
                    first_flag=1
                end
                buff=buff.."      心情+"..v.."\n"
            elseif(k=="energy") then
                if(first_flag==0) then
                    buff=buff.."  ——————————\n  道具加成：\n"
                    first_flag=1
                end
                buff=buff.."      精力+"..v.."\n"
            end
        end
    end
    config.msg.record = config.msg.record:gsub("{name}", name)
    config.msg.record = config.msg.record:gsub("{gender}", gender)
    config.msg.record = config.msg.record:gsub("{job}", job)
    config.msg.record = config.msg.record:gsub("{intro}", intro)
    config.msg.record = config.msg.record:gsub("{int}", int)
    config.msg.record = config.msg.record:gsub("{con}", con)
    config.msg.record = config.msg.record:gsub("{energy}", energy)
    config.msg.record = config.msg.record:gsub("{energy_limit}", energy_limit)
    config.msg.record = config.msg.record:gsub("{wil}", wil)
    config.msg.record = config.msg.record:gsub("{luc}", luc)
    config.msg.record = config.msg.record:gsub("{mood}", mood)
    config.msg.record = config.msg.record:gsub("{mood_limit}", mood_limit)
    config.msg.record = config.msg.record:gsub("{semester}", semester)
    config.msg.record = config.msg.record:gsub("{credit}", credit)
    config.msg.record = config.msg.record:gsub("{point}", point)
    config.msg.record = config.msg.record:gsub("{achi_num}", achi_num)
    config.msg.record = config.msg.record:gsub("{buff}", buff)
    return config.msg.record
end