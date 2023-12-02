writemsg = "书写留言"
readmsg = "留言显形"
mymsg = "我的留言"
deletemsg = "擦除留言"

config = {
    msg = {
        msgphoto_err="图片或表情包塞不进留言板呐qwq",
        msgsuccess="书写留言成功！",
        deletesuccess="您发送的上一条留言已删除！"
    }
}

msg_order = {}
msg_order[writemsg] = "writeMessage"
msg_order[readmsg] = "readMessage"
msg_order[mymsg] = "viewMyMessage"
msg_order[deletemsg] = "deleteMessage"

function writeMessage(msg)
    local QQ = tostring(msg.fromQQ)
    local msgcontent = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#writemsg+1)
    local writetime = os.date("*t")
    local _, photo_num = string.find(msgcontent, "%[CQ:image,file=")
    if(photo_num) then
        return config.msg.msgphoto_err
    end

    board_information="board.json"
    board_data = getSelfData(board_information)
    messages = board_data:get(nil, {})
    if(messages == nil)then
        messages = {}
    end

    local msgnumber = 1
    for i,j in pairs(messages) do
        msgnumber = msgnumber + 1
    end
    local msgid = tostring(msgnumber)
    local message = {
        authorQQ = QQ,
        content = msgcontent,
        time = writetime
    }
    messages[tostring(msgnumber)] = message
    board_data:set(messages)

    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end

    players[QQ]["Count"]["board"] = players[QQ]["Count"]["board"]+1
    data:set(players)
    return config.msg.msgsuccess
end

function readMessage(msg)
    board_information="board.json"
    board_data = getSelfData(board_information)
    messages = board_data:get(nil, {})
    if(messages == nil)then
        messages = {}
    end

    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end

    local msgboard = "╔                                 ╗\n              留言板\n╚                                 ╝\n"
    local msgnum = 0
    for i,j in pairs(messages) do
        msgnum = msgnum + 1
    end
    if (msgnum==0) then
        msgboard=msgboard.."\n暂无留言"
    else
        local numlimit=msgnum-9
        if (numlimit<1) then
            numlimit=1
        end
        local keylist={}
        local n=0
        for key,val in pairs(messages) do
            n=n+1
            keylist[n]=key
        end
        for i=1,n do
            for j=1,n-1 do
                if(tonumber(keylist[j])>tonumber(keylist[j+1])) then
                    local t1=""
                    local t2=""
                    t1=keylist[j]
                    t2=keylist[j+1]
                    keylist[j]=t2
                    keylist[j+1]=t1
                end
            end
        end
        for i=numlimit,msgnum do
            for key,val in pairs(messages) do
                if (key==keylist[i]) then
                    local QQ=val["authorQQ"]
                    local content=val["content"]
                    local year=val["time"]["year"]
                    local month=val["time"]["month"]
                    local day=val["time"]["day"]
                    local hour=tostring(val["time"]["hour"])
                    local min=tostring(val["time"]["min"])
                    local sec=tostring(val["time"]["sec"])
                    local playername=players[QQ]["Info"]["Nickname"]
                    if (#hour==1) then
                        hour="0"..hour
                    end
                    if (#min==1) then
                        min="0"..min
                    end
                    if (#sec==1) then
                        sec="0"..sec
                    end
                    msgboard=msgboard.."\n"..year.."年"..month.."月"..day.."日  "..hour..":"..min..":"..sec.."\n"
                    msgboard=msgboard.."    「"..playername.."」："..content.."\n"
                end
            end
        end
    end
    return msgboard
end

function viewMyMessage(msg)
    local QQ = tostring(msg.fromQQ)

    board_information="board.json"
    board_data = getSelfData(board_information)
    messages = board_data:get(nil, {})
    if(messages == nil)then
        messages = {}
    end

    player_information="player.json"
    data = getSelfData(player_information)
    players = data:get(nil, {})
    if(players == nil)then
        players = {}
    end

    local mymsgboard = "╔                                 ╗\n            我的留言\n╚                                 ╝\n"
    local flag = 0
    local n=0
    local keylist={}
    for key,val in pairs(messages) do
        local playerQQ = val["authorQQ"]
        if (playerQQ==QQ) then
            flag=1
            n=n+1
            keylist[n]=key
        end
    end
    for i=1,n do
        for j=1,n-1 do
            if(tonumber(keylist[j])>tonumber(keylist[j+1])) then
                local t1=""
                local t2=""
                t1=keylist[j]
                t2=keylist[j+1]
                keylist[j]=t2
                keylist[j+1]=t1
            end
        end
    end
    for i=1,n do
        for key,val in pairs(messages) do
            if (key==keylist[i]) then
                local content=val["content"]
                local year=val["time"]["year"]
                local month=val["time"]["month"]
                local day=val["time"]["day"]
                local hour=tostring(val["time"]["hour"])
                local min=tostring(val["time"]["min"])
                local sec=tostring(val["time"]["sec"])
                if (#hour==1) then
                    hour="0"..hour
                end
                if (#min==1) then
                    min="0"..min
                end
                if (#sec==1) then
                    sec="0"..sec
                end
                mymsgboard=mymsgboard.."\n"..year.."年"..month.."月"..day.."日  "..hour..":"..min..":"..sec.."\n"
                mymsgboard=mymsgboard.."    "..content.."\n"
            end
        end
    end
    if (flag==0) then
        msgboard=msgboard.."\n暂无留言"
    end  
    return mymsgboard
end

function deleteMessage(msg)
    local QQ = tostring(msg.fromQQ)

    board_information="board.json"
    board_data = getSelfData(board_information)
    messages = board_data:get(nil, {})
    if(messages == nil)then
        messages = {}
    end

    local lastmsgid = "1"
    local msgnum = 0
    for key,val in pairs(messages) do
        local playerQQ = val["authorQQ"]
        msgnum=msgnum+1
        if (playerQQ==QQ) then
            if (tonumber(key)>tonumber(lastmsgid)) then
                lastmsgid=key
            end
        end
    end
    local lastmsgnum=tonumber(lastmsgid)
    table.remove(messages,lastmsgid)
    newmessages={}
    for n=1,msgnum-1 do
        newmessages[tostring(n)]=messages[n]
    end
    board_data:set(newmessages)
    return config.msg.deletesuccess
end