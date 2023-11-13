info = "info"
config = {
    msg = {
        record="╔═══════════════╗\n            个人档案\n  姓名  {name}\n  性别 {gender}      职业 {job}\n  个人简介\n  {intro}\n  ——————————\n   主属性        每日状态\n  智力  {int}    精力\n  体质 {con}    {energy}/100\n  意志 {wil}    心情\n  运气 {luc}    {mood}/100\n  ——————————\n 学年  {semester}       学分 {credit}\n  积分  {point}         成就数 {achi_num}\n╚═══════════════╝\n"
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
    local name = players[QQ]["Info"]["Nickname"]
    local gender = players[QQ]["Info"]["Gender"]
    local job = players[QQ]["Info"]["Job"]
    local intro = players[QQ]["Info"]["Introduction"]
    local int = players[QQ]["MainAtt"]["INT"]
    local con = players[QQ]["MainAtt"]["CON"]
    local wil = players[QQ]["MainAtt"]["WIL"]
    local luc = players[QQ]["MainAtt"]["LUC"]
    local energy = players[QQ]["DailyAtt"]["energy"]
    local mood = players[QQ]["DailyAtt"]["mood"]
    local semester = players[QQ]["Mainline"]["Semester"]
    local credit = players[QQ]["Mainline"]["credit"]
    local point = players[QQ]["points"]
    local achi_num = #players[QQ]["Achievement"]
    config.msg.record = config.msg.record:gsub("{name}", name)
    config.msg.record = config.msg.record:gsub("{gender}", gender)
    config.msg.record = config.msg.record:gsub("{job}", job)
    config.msg.record = config.msg.record:gsub("{intro}", intro)
    config.msg.record = config.msg.record:gsub("{int}", int)
    config.msg.record = config.msg.record:gsub("{con}", con)
    config.msg.record = config.msg.record:gsub("{energy}", energy)
    config.msg.record = config.msg.record:gsub("{wil}", wil)
    config.msg.record = config.msg.record:gsub("{luc}", luc)
    config.msg.record = config.msg.record:gsub("{mood}", mood)
    config.msg.record = config.msg.record:gsub("{semester}", semester)
    config.msg.record = config.msg.record:gsub("{credit}", credit)
    config.msg.record = config.msg.record:gsub("{point}", point)
    config.msg.record = config.msg.record:gsub("{achi_num}", achi_num)
    return   config.msg.record
end