chat = "社交"
board = "留言板"
bottle = "漂流瓶"
social_event = "查看活动"
config = {
    msg = {
        chatmenu="╔══════════════════╗\n                  社交选择\n  ————————————\n   指令及效果\n    「留言板」 查看留言板\n    「漂流瓶」 查看漂流瓶\n    「查看活动」 查看社交事件\n╚══════════════════╝",
        brdmenu="╔═══════════════╗\n              留言板\n  ——————————\n   指令:\n       「书写留言+留言内容」\n       「留言显形」\n       「我的留言」\n       「擦除留言」\n╚═══════════════╝\ntips:1.「擦除留言」为删除自己的上一条留言\n       2.「留言显形」为显示最新10条留言\n       3.留言请勿使用图片或表情",
        btlmenu="╔═══════════════╗\n              漂流瓶\n  ——————————\n   指令:\n       「扔漂流瓶」\n       「捡漂流瓶」\n       「跳进海里」\n       「查找瓶子」\n       「删除瓶子」\n╚═══════════════╝",
        socialevent=""
    }
}
msg_order = {}
msg_order[chat] = "Chatmenu"
msg_order[board] = "Boardmenu"
msg_order[bottle] = "Bottlemenu"
msg_order[social_event] = "getSocialEvent"

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