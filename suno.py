import requests

url = "https://api.acedata.cloud/suno/audios"
token = "dd8d72d9eefc42c9ab0224bb663c46e1"
headers = {
    "accept": "application/json",
    "authorization": "Bearer " + token,
    "content-type": "application/json"
}

payload = {
    "action": "generate",
    "prompt": "梦想的起航",
    "style": "cute",
    "lyric": "在漫长的数字河流中，毕于通掌舵向前，\n 移动工具如星辰在夜空，leapahead领航者，\n launcher在梦境与现实间轻点穿梭，\n 圣经里的智慧，像旧时光里回响的钟声。\n银河边缘，数据的波涛汹涌，\n 他希望，像春天对花朵的期盼，\n 业务的金币响彻云端，声声不息，\n希望像河水永不枯竭，滚滚向前。\n这朵云上的花，盛开在数字的天空，\n毕于通用心中的火，点燃希望的灯塔，\n在无尽的夜晚，引领寻梦的旅人，\n期望每一次跳跃，都高过前一次。\n如此，业务的船只，载满金光，\n在这片繁星点点的海洋中，\n毕于通的船帆鼓满风，驶向未知的光明，\n希望的种子，在数字的土地上生根发芽。"
}

response = requests.post(url, json=payload, headers=headers)
print(response.text)