s="sign"
ocnfig={
    msg={
        sign_success="签到成功！积分+{point}"
    }
}
msg_order={}
msg_order[s]="sign"

player_information="player.json"
data = getSelfData(player_information)
players = data:get(nil, {})
if(players == nil)then
    players = {}
end
function sign(msg)
    QQ=tostring(msg.fromQQ)
    players[QQ]["Count"]["sign"]=players[QQ]["Count"]["sign"]+1
    players[QQ]["points"]=players[QQ]["points"]+10+math.random(1, 10)
    data:set(players)
    config.msg.sign_success = config.msg.sign_success:gsub("{point}", point)
    return config.msg.sign_success
end