mod="简介"
config={
    msg={
        update_intro="个人简介保存成功！"
    }
}
order_msg={}
order_msg[mod]="updateIntro"

function updateIntro(msg)
    local introduction = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#mod+1)
    local QQ=tostring(msg.fromQQ)
    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end
    if (players[QQ]["Info"]["Nickname"]==nil) then 
        return "未创建角色，请先创建角色「创建新角色」"
    end
    players[QQ]["Info"]["Introduction"]=introduction
    data:set(players)
    return config.msg.update_intro
end