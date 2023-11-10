--[[
(更新时间2023.6.17)
漂流瓶jsonReforged by 豹猫ocelot
使用json重写了兔兔的整个漂流瓶，配置也用json（）
新增了查询/删除指定瓶子的功能，为 查找瓶子/删除瓶子 id=【id】/qq=【qq】
有bug及时反馈qq1226421749
↓↓↓↓↓↓请在下方修改配置↓↓↓↓↓↓
]]
--以下是关键词，修改后需要重载
throw_bottle_order = "扔漂流瓶"
pick_bottle_order = "捡漂流瓶"
drown_self_order = "跳进海里"
search_bottle = "查找瓶子"
del_bottle = "删除瓶子"
reset_order = "漂流瓶初始化"
--以下是插件配置，修改后无需重载
bottle_name = "bottle_letter.json"--文件名，勿动
config = {
    dis_priv = true,--禁用小窗
    monitor_mode = 0,--监视模式，0禁用，1群聊，2私聊，3广播
    monitor_subject = 123456789,--监视的群或私聊窗口
    mode3notice = 0,--监视模式为广播时发送广播的窗口
    burn_after_read = true,--阅后即焚，即瓶子捡到不放回
    throw_max = 100,--每日丢瓶子次数
    throw_cd = 60,--扔瓶子cd
    pick_max = 10,--每日捡瓶子次数
    pick_cd = 60,--捡瓶子cd
    drown_max = 1,--每日跳海次数
    drown_cd = 60,--跳海cd
    maxlen = 0,--字符串最大长度，大于0生效
    bottle_type = {--下面是可能的瓶子类型，可以按照格式增加，要注意瓶子样式与顺序有关
        "啤酒瓶",
        "塑料瓶",
        "玻璃瓶",
        "牛奶瓶",
        "娃哈哈AD钙奶瓶",
        "威士忌酒瓶",
        "伏特加酒瓶",
        "莫洛托夫鸡尾酒瓶",
        "可乐瓶",
        "春药瓶",
        "宠物小精灵瓶",
        "化妆瓶",
        "葡萄酒瓶",
        "安眠药瓶",
        "止咳糖浆瓶",
        "五粮液瓶",
        "江小白瓶",
        "梦境增强剂瓶",
        "克莱因瓶",
        "安瓿瓶",
        "镶金的矿泉水瓶",
        "皇帝的新瓶",
        "奶瓶",
        "伏特加瓶"
    },
    msg = {--下面是回复词
        help = "漂流瓶jsonReforged by 豹猫ocelot\n输入“{tb} 消息”发送留言。\n输入“{pb}”来获取他人的留言。\n输入“{dr}”来查看当前漂流瓶数量。",
        throw_max = "{nick}今天已经扔了很多漂流瓶了，请不要造成海洋污染——",
        waiting_cd = "",--在cd时的提示
        photo_err = "图片或表情包塞不进瓶子呐qwq\n如果你真的想发，可以直接发送cq码",
        len_err = "瓶子被你撑碎了×",--字符串过长
        throw_ok = "你将一个写着{letter}的纸条塞入瓶中扔进大海，希望有人捞到吧~",
        get_bottle = "你在海边捡到了来自{user}的{bottle}，打开瓶子，里面有一张纸条，写着：{letter}",
        empty_err = "现在海里空无一物，不信你自己跳进海里看看~",
        drown_fail = "温暖的海水再一次包覆住你的身体……\n你放松全身，任由海浪推着你漂流，朦胧中好像看见{number}道影子漂在远处。\n……\n转眼间你被推上原先所处的海岸，风浪一如既往，只有一团泡沫轻抚你的脸颊。",
        drown_success = "你缓缓走入大海，感受着海浪轻柔地拍打着你的小腿，膝盖……\n波浪卷着你的腰腹，你感觉有些把握不住平衡了……\n……\n你沉入海中，{number}个物体与你一同沉浮。\n不知何处涌来一股暗流，你失去了意识。",
        drown_text = "{img}\n海面飘来了{user}的浮尸……\n他于{time}沉入深海……\n愿深蓝之意志保佑他的灵魂。",
        pick_max = "{nick}今天已经获取很多漂流瓶了。\n回忆虽然诱人，但也不得过量服用。",
        reply_no_perm = "权限不足",
        search_id_not_found = "该id不存在",
        search_qq_not_found = "没有找到该qq的瓶子",
        time = "%.0f年%.0f月%.0f日%.0f:%.0f"--时间格式
    }
}
--↑↑↑↑↑↑上面是配置部分↑↑↑↑↑↑
msg_order = {}
msg_order[throw_bottle_order] = "throw_bottle"
msg_order[pick_bottle_order] = "pick_bottle"
msg_order[drown_self_order] = "bottle_num"
msg_order[search_bottle] = "search"
msg_order[del_bottle] = "delete"

function b2t(bottle)
    local time = os.date("*t", bottle.time)
    local time = string.format("%.0f-%.0f-%.0f %.0f:%.0f",time.year,time.month,time.day,time.hour,time.min)
    if(bottle.type == "bottle")then
        if(bottle.group ~= "")then
            return string.format("%s\n来自：群%s,QQ%s\n内容：%s\n样式：%s(%d)",time,bottle.group,bottle.QQ,bottle.message,config.bottle_type[bottle.style],bottle.style)
        else
            return string.format("%s\n来自：QQ%s\n内容：%s\n样式：%s(%d)",time,bottle.QQ,bottle.message,config.bottle_type[bottle.style],bottle.style)
        end
    else
        return "来自"..bottle.QQ.."尸体"
    end
end

data = getSelfData(bottle_name)
bottles = data:get(nil, {})
if(bottles == nil)then
    bottles = {}
end

function throw_bottle(msg)
    if(config.dis_priv==true and msg.fromGroup=="0")then--小窗检测
        return ""
    end
    local letter = string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#throw_bottle_order+1)
    local _, photo_num = string.find(letter, "%[CQ:image,file=")
    if (#letter == 0) then--返回帮助
        msg.tb = throw_bottle_order
        msg.pb = pick_bottle_order
        msg.dr = drown_self_order
        return config.msg.help
    elseif(getUserToday(msg.fromQQ,"DB_everyday_throw",0)>= config.throw_max) then--检测每日次数
        return config.msg.throw_max
    elseif(getUserToday(msg.fromQQ,"DB_throw_cd",os.time()-1)>= os.time()) then--检测cd
        return config.msg.waiting_cd
    elseif(photo_num) then--检测是否有图片
        return config.msg.photo_err
    elseif(#letter > config.maxlen and config.maxlen > 0) then--长度检测
        return config.msg.len_err
    else
        local bottle = {--封装表格
            type = "bottle",
            group = msg.fromGroup,
            QQ = msg.fromQQ,
            message = letter,
            style = math.random(#config.bottle_type),
            time = os.time()
        }
        msg.letter = letter
        table.insert(bottles,bottle)--添加
        data:set(bottles)--储存
        if(config.monitor_mode==1)then -- 群
            sendMsg("检测到新瓶子:"..b2t(bottle),config.monitor_subject,0)
        elseif(config.monitor_mode==2)then -- 私聊
            sendMsg("检测到新瓶子:"..b2t(bottle),0,config.monitor_subject)
        elseif(config.monitor_mode==3)then	-- 广播
            log("检测到新瓶子:"..b2t(bottle),config.mode3notice)
        end
        setUserToday(msg.fromQQ, "DB_everyday_throw", getUserToday(msg.fromQQ, "DB_everyday_throw", 0)+1)--次数
        setUserToday(msg.fromQQ, "DB_throw_cd", os.time() + config.throw_cd)--设置cd
        return config.msg.throw_ok
    end
end
function pick_bottle(msg)
    msg.letter = letter
    if(config.dis_priv==true and msg.fromGroup=="0")then
        return ""
    elseif(getUserToday(msg.fromQQ,"DB_everyday_pick",0)>=config.pick_max) then
        return config.msg.pick_max
    elseif(getUserToday(msg.fromQQ,"DB_pick_cd",os.time()-1)>= os.time()) then
        return config.msg.waiting_cd
    else
        if(#bottles == 0) then--没瓶子了
            return config.msg.empty_err
        else
            i = ranint(1,#bottles)--随机抽一个
            letter_text = bottles[i]
            if(config.burn_after_read == true ) then--是否阅后即焚
                table.remove(bottles,i)
                data:set(bottles)
            end
            setUserToday(msg.fromQQ, "DB_everyday_pick", getUserToday(msg.fromQQ, "DB_everyday_pick", 0)+1)--次数和cd
            setUserToday(msg.fromQQ, "DB_pick_cd", os.time()+config.pick_cd)
            if(letter_text.type == "bottle")then--瓶子
                msg.user = getUserConf(letter_text.QQ, "nick#"..letter_text.group,getUserConf(letter_text.QQ, "nick#","用户("..letter_text.QQ)..")")
                msg.bottle = config.bottle_type[letter_text.style] or "漂流瓶"
                msg.letter = letter_text.message
                return config.msg.get_bottle
            else--尸体
                time = os.date("*t", letter_text.time)
                msg.img = "[CQ:image,url=http://q1.qlogo.cn/g?b=qq&nk="..letter_text.QQ.."&s=640]"
                msg.user = getUserConf(letter_text.QQ, "nick#"..letter_text.group,getUserConf(letter_text.QQ, "nick#","用户("..letter_text.QQ)..")")
                msg.time = string.format(config.msg.time,time.year,time.month,time.day,time.hour,time.min)
                return config.msg.drown_text
            end
        end
    end
end
function bottle_num(msg)--跳海
    if(config.dis_priv==true and msg.fromGroup=="0")then
        return ""
    elseif(getUserToday(msg.fromQQ,"DB_drown_cd",os.time()-1)>= os.time()) then--cd
        return config.msg.waiting_cd
    elseif ( getUserToday(msg.fromQQ,"DB_everyday_drown",0) >= config.drown_max) then--不死
        setUserToday(msg.fromQQ, "DB_drown_cd", os.time() + config.drown_cd)
        msg.number = #bottles
        return config.msg.drown_fail
    else--死
        local bottle = {--封装
            type = "corpse",
            group = msg.fromGroup,
            QQ = msg.fromQQ,
            time = os.time()
        }
        msg.letter = letter
        table.insert(bottles,bottle)
        data:set(bottles)--保存
        setUserToday(msg.fromQQ, "DB_everyday_drown", getUserToday(msg.fromQQ, "DB_everyday_drown", 0)+1)
        setUserToday(msg.fromQQ, "DB_drown_cd", os.time() + config.drown_cd)
        msg.number = #bottles-1
        return config.msg.drown_success
    end
end
function search(msg)--搜索
    if(getUserConf(msg.fromQQ,"trust",0) < 4 and user_qq ~= msg.fromQQ)then
        return config.msg.reply_no_perm
    end
    local thing = string.lower(string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#search_bottle+1))
    if(string.find(thing,"qq="))then--qq
        local search_QQ = string.sub(thing, #"qq="+1)
        local bts = {}
        local have = false
        for i = 1,#bottles do
            if(bottles[i].QQ == search_QQ)then
                table.insert(bts,"#"..i..":"..b2t(bottles[i]).."\n")
                have = true
            end
        end
        if(have == true)then
            return table.concat(bts,"\n")
        end
        return config.msg.search_qq_not_found
    elseif(string.find(thing,"id="))then--下标
        local id = tonumber(string.sub(thing, #"id="+1))
        if(id>#bottles)then
            return config.msg.search_id_not_found
        end
        return b2t(bottles[id])
    else
        return "参数非法"
    end
end
function delete(msg)
    if(getUserConf(msg.fromQQ,"trust",0) < 4 and user_qq ~= msg.fromQQ)then
        return config.msg.reply_no_perm
    end
    local thing = string.lower(string.match(msg.fromMsg,"[%s]*(.-)[%s]*$",#del_bottle+1))
    if(string.find(thing,"qq="))then
        local search_QQ = string.sub(thing, #"qq="+1)
        local bts = {}
        local have = false
        local j=0
        for i = 1,#bottles do
            if(bottles[i-j].QQ == search_QQ)then
                table.remove (bottles, i-j)
                j=j+1
                have = true
            end
        end
        if(have == true)then
            data:set(bottles)
            return "已清除所有QQ="..search_QQ.."的漂流瓶"
        end
        return config.msg.search_qq_not_found
    elseif(string.find(thing,"id="))then
        local id = tonumber(string.sub(thing, #"id="+1))
        if(id>#bottles)then
            return config.msg.search_id_not_found
        end
        table.remove (bottles, id)
        data:set(bottles)
        return "已清除id="..id.."的漂流瓶"
    else
        return "参数非法"
    end
end