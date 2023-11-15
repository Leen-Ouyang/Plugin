shop = "商店"
config = {
    msg = {
        shopmenu="╔═══════════════╗\n            远程商店\n  ——————————\n   指令：\n    「积分商店」\n    「成就商店」\n    「特殊商店」\n╚═══════════════╝\ntips:特殊事件所需部分物件需要从特殊商店购买"
    }
}
msg_order = {}
msg_order[shop] = "Shopmenu"
function Shopmenu()
    return config.msg.shopmenu
end