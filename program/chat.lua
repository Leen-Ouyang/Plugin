chat = "chat"
board = "brd"
bottle = "btl"
vnt = "vnt"
config = {
    msg = {
        chatmenu="╔═══════════════╗\n            社交选择\n  ——————————\n   指令     效果\n 「brd」 留言板\n 「btl」  漂流瓶\n 「vnt」  查看社交事件\n╚═══════════════╝",
        brdmenu="╔═══════════════╗\n              留言板\n  ——————————\n   指令     效果\n 「wrt」 书写留言\n 「see」  留言显形\n 「mine」我的留言\n 「dlt」  擦出留言\n╚═══════════════╝",
        btlmenu="╔═══════════════╗\n              漂流瓶\n  ——————————\n   指令:\n       扔漂流瓶\n       捡漂流瓶\n       跳进海里\n       查找瓶子\n       删除瓶子\n       漂流瓶初始化\n╚═══════════════╝",
        socialevent=""
    }
}
msg_order = {}
msg_order[chat] = "Chatmenu"
msg_order[board] = "Boardmenu"
msg_order[bottle] = "Bottlemenu"
msg_order[vnt] = "getSocialEvent"

function Chatmenu()
    return config.msg.chatmenu
end

function Boardmenu()
    return config.msg.brdmenu
end

function Bottlemenu()
    return config.msg.btlmenu
end

function getSocialEvent()
    return config.msg.socialevent
end