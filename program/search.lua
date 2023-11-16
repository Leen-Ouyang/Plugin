search_event_order = "事件查看"
Temp = "temp.json" --temp json文件夹读取
Event = "Event.json"
config = {
    
}
msg_order = {}
msg_order[search_event_order] = "search_event"

data = getSelfData(Temp)
temp = data:get(nil,{})
if(temp == nil)then
    temp = {}
end

data1 = getSelfData(Event)
event = data1:get(nil,{})
if(event == nil)then
    event = {}
end



function search_event(msg)
    local QQ = msg.fromQQ
    local s = "今日已完成事件：\n"
    --查看已完成事件
    if #temp[QQ].daily_done == 0 then
        s = s.."  你还没有做过每日事件哦\n"
    else
        s = s.."  每日事件：\n"
        for i = 1, #temp[QQ].daily_done do 
            s = s.."    "..event["Daily"][temp[QQ].daily_done[i]][1]["title"].."\n"
        end
    end

    if #temp[QQ].weekly_done == 0 then
        s = s.."  你还没有做过每周事件哦\n"
    else
        s = s.."  每周事件：\n"
        for i = 1, #temp[QQ].weekly_done do 
            s = s.."    "..event["Weekly"][temp[QQ].weekly_done[i]][1]["title"].."\n"
        end
    end

    --查看下一项每日事件，以及相关具体信息
    if temp[QQ].next_daily.type == "nil" then
        temp[QQ].next_daily.type = nil
    end
    if(temp[QQ].next_daily.type == nil)then
        s = s.."  当前还没生成每日事件"..'\n'
    elseif(temp[QQ].next_daily.type=="Daily")then
        s = s.."  下一项每日事件："..event["Daily"][temp[QQ].next_daily.num][1]["title"].."\n"
    end
    --查看下一项每周事件，以及相关具体信息
    if temp[QQ].next_weekly.type == "nil" then
        temp[QQ].next_weekly.type = nil
    end
    if(temp[QQ].next_weekly.type == nil)then
        s = s.."  当前还没生成每周事件"..'\n'
    elseif(temp[QQ].next_weekly.type=="Weekly")then
        s = s.."  下一项每周事件："..event["Weekly"][temp[QQ].next_weekly.num][1]["title"].."\n"
    end
    --考试的话
    if(temp[QQ].next_daily.type=="Exam")then 
        s = s.."  该准备考试了！".."\n"
    end

    data1:set(event)
    data:set(temp)
    return s
end
