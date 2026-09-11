# -*- coding: utf-8 -*-
"""
Bo sung THEM cau hoi vao kho de (khong xoa/sua cau cu, khong doi questionsPerSession)
cho 6 bai NORMAL cua topic 1 (Loi chao, tam biet) va 6 bai NORMAL cua topic 2
(Goi do an, do uong), theo dung quy uoc da dung o migration V44:

  - SELECT_IMAGE / TRANSLATE_TO_VN (de bai tieng Nhat) / LISTEN_AND_SELECT /
    LISTEN_AND_ARRANGE / SPEAKING -> co audio_url (MP3 that, edge-tts giong
    ja-JP-NanamiNeural, rate -10%), dat ten theo ID cau hoi that su duoc INSERT
    (q_<id>.mp3), giong het cach lam cua du lieu cu.
  - TRANSLATE_TO_JP (de bai tieng Viet) -> KHONG audio o cau hoi; dap an tieng
    Nhat kem romaji trong metadata de FE tu doc bang giong may khi cham vao
    (tinh nang nay co san trong app, khong dong code).
  - SELECT_IMAGE chi dung lai 9 tu da co san icon (khong tao icon moi, tranh
    lech phong cach voi bo icon thu cong da co).
  - Tai su dung file audio cu neu trung noi dung (vi du "ohayou" da co
    q_1968.mp3) thay vi sinh trung lap.

Chay:  python add_topic1_topic2_pool.py            (chi ghi DB, bo qua neu da chay roi)
       python add_topic1_topic2_pool.py --audio-only  (chi sinh audio con thieu, khong dung sau khi da insert xong)
"""
import asyncio
import json
import os
import random
import sys

import pymysql

random.seed(20260908)

DB = dict(host="127.0.0.1", port=3307, user="nihongo_user", password="1234",
          database="nihongo_db", charset="utf8mb4")

BASE = os.path.dirname(os.path.abspath(__file__))
UPLOADS = os.path.abspath(os.path.join(BASE, "..", "..", "uploads"))
AUDIO_DIR = os.path.join(UPLOADS, "audios", "questions")
VOICE = "ja-JP-NanamiNeural"

TOPIC1 = {"L1": 149, "L2": 150, "L3": 151, "L4": 152, "L5": 153, "L6": 154}
TOPIC2 = {"L1": 157, "L2": 158, "L3": 159, "L4": 160, "L5": 161, "L6": 162}

# anh da co san (KHONG tao icon moi) -- chi dung lai cho SELECT_IMAGE
IMG = {
    "おはよう": "/uploads/images/vocab_ohayou.png",
    "こんにちは": "/uploads/images/vocab_konnichiwa.png",
    "こんばんは": "/uploads/images/vocab_konbanwa.png",
    "さようなら": "/uploads/images/vocab_sayounara.png",
    "お茶": "/uploads/images/vocab_ocha.png",
    "ご飯": "/uploads/images/vocab_gohan.png",
    "水": "/uploads/images/vocab_mizu.png",
    "パン": "/uploads/images/vocab_pan.png",
    "コーヒー": "/uploads/images/vocab_koohii.png",
}

# romaji cho MOI token co the xuat hien lam dap an / thanh sap xep (ca tu cu va tu moi)
ROMAJI = {
    # topic 1 - da day
    "おはよう": "ohayou", "こんにちは": "konnichiwa", "こんばんは": "konbanwa",
    "さようなら": "sayounara", "またね": "mata ne",
    "おはようございます": "ohayou gozaimasu", "また明日": "mata ashita",
    "じゃあね": "jaa ne", "お休みなさい": "oyasuminasai",
    "失礼します": "shitsurei shimasu", "いってきます": "itte kimasu",
    "いってらっしゃい": "itte rasshai", "ただいま": "tadaima",
    "おかえりなさい": "okaerinasai", "いただきます": "itadakimasu",
    "ごちそうさまでした": "gochisousama deshita", "お疲れ様です": "otsukaresama desu",
    "お先に失礼します": "osaki ni shitsurei shimasu", "お元気ですか": "ogenki desu ka",
    "元気です": "genki desu", "まあまあです": "maamaa desu",
    "また": "mata", "明日": "ashita", "ございます": "gozaimasu", "ね": "ne",
    "いって": "itte", "きます": "kimasu", "らっしゃい": "rasshai",
    "いただき": "itadaki", "ます": "masu", "ごちそうさま": "gochisousama", "でした": "deshita",
    "お元気": "ogenki", "ですか": "desu ka", "まあまあ": "maamaa", "です": "desu",
    "お疲れ様": "otsukaresama",
    # topic 1 - moi
    "はじめまして": "hajimemashite", "よろしくお願いします": "yoroshiku onegaishimasu",
    "よろしく": "yoroshiku", "お願いします": "onegaishimasu",
    "名前": "namae", "お名前は？": "onamae wa?", "お名前": "onamae", "は？": "wa?",
    "お久しぶりです": "ohisashiburi desu", "お久しぶり": "ohisashiburi",
    "気をつけてね": "ki wo tsukete ne", "気を": "ki o", "つけて": "tsukete",
    "乾杯": "kanpai", "ごちそうさま。": "gochisousama.",
    "大丈夫です": "daijoubu desu", "大丈夫": "daijoubu",
    "どうですか": "dou desu ka", "どう": "dou",
    # topic 2 - da day
    "お茶": "ocha", "ご飯": "gohan", "水": "mizu", "パン": "pan", "コーヒー": "koohii",
    "寿司": "sushi", "ジュース": "juusu", "肉": "niku", "魚": "sakana",
    "ください": "kudasai", "お願いします2": "onegaishimasu",
    "卵": "tamago", "野菜": "yasai", "メニュー": "menyuu", "ラーメン": "raamen",
    "すみません": "sumimasen", "これはいくらですか": "kore wa ikura desu ka",
    "これ": "kore", "は": "wa", "いくら": "ikura", "いくらですか": "ikura desu ka",
    "注文": "chuumon", "お会計": "okaikei", "を": "o", "と": "to",
    "ラーメンと野菜をお願いします": "raamen to yasai o onegaishimasu",
    "すみません、お会計をお願いします。": "sumimasen, okaikei o onegaishimasu.",
    "ただいま。おかえりなさい。": "tadaima. okaerinasai.",
    # topic 2 - moi
    "ビール": "biiru", "おいしいです": "oishii desu", "おいしい": "oishii",
    "ケーキ": "keeki", "アイス": "aisu", "とても": "totemo",
    "一つ": "hitotsu", "二つ": "futatsu", "アイスコーヒー": "aisu koohii",
    "ご飯を一つください": "gohan o hitotsu kudasai",
    "ラーメンを二つください": "raamen o futatsu kudasai",
    "ケーキを一つください": "keeki o hitotsu kudasai",
    "ケーキを二つください": "keeki o futatsu kudasai",
    "ビールをください": "biiru o kudasai",
    "ケーキをお願いします": "keeki o onegaishimasu",
    "とてもおいしいです": "totemo oishii desu",
    "すみません、これはいくらですか。": "sumimasen, kore wa ikura desu ka.",
    "はじめまして。よろしくお願いします。": "hajimemashite. yoroshiku onegaishimasu.",
    "お久しぶりです。お元気ですか。": "ohisashiburi desu. ogenki desu ka.",
    "いただきます。ごちそうさま。": "itadakimasu. gochisousama.",
    "ビールをください。とてもおいしいです。": "biiru o kudasai. totemo oishii desu.",
}

AUDIO_NEEDING_TYPES = {"SELECT_IMAGE", "TRANSLATE_TO_VN", "LISTEN_AND_SELECT",
                        "LISTEN_AND_ARRANGE", "SPEAKING"}

conn = pymysql.connect(**DB)
cur = conn.cursor()

audio_cache = {}   # text tieng Nhat -> url mp3 co san (tai su dung, khong sinh trung)
pending_audio = []  # [(question_id, text)] can sinh audio moi


def preload_audio_cache():
    lesson_ids = list(TOPIC1.values()) + list(TOPIC2.values())
    fmt = ",".join(["%s"] * len(lesson_ids))
    cur.execute(
        "SELECT q.id, q.metadata_json, q.audio_url, "
        "(SELECT o.option_text FROM lesson_question_options o "
        " WHERE o.question_id=q.id AND o.is_correct=1 ORDER BY o.order_index LIMIT 1) "
        f"FROM lesson_questions q WHERE q.audio_url IS NOT NULL AND q.lesson_id IN ({fmt})",
        lesson_ids,
    )
    for qid, meta, url, correct_opt in cur.fetchall():
        m = json.loads(meta) if meta else {}
        text = m.get("kana") or m.get("jp") or correct_opt
        if text and text not in audio_cache:
            audio_cache[text] = url
    print("Audio cache: %d muc co san duoc tai su dung" % len(audio_cache))


def insert_question(lesson_id, qtype, meta):
    cur.execute(
        "INSERT INTO lesson_questions (lesson_id, question_type, question_text, "
        "audio_url, image_url, metadata_json) VALUES (%s,%s,NULL,NULL,NULL,%s)",
        (lesson_id, qtype, json.dumps(meta, ensure_ascii=False) if meta else None),
    )
    return cur.lastrowid


def attach_audio(qid, text, qtype):
    if qtype not in AUDIO_NEEDING_TYPES or not text:
        return
    cached = audio_cache.get(text)
    if cached:
        cur.execute("UPDATE lesson_questions SET audio_url=%s WHERE id=%s", (cached, qid))
        return
    url = "/uploads/audios/questions/q_%d.mp3" % qid
    cur.execute("UPDATE lesson_questions SET audio_url=%s WHERE id=%s", (url, qid))
    audio_cache[text] = url
    pending_audio.append((qid, text))


def insert_option(qid, text, correct, order_index, image=None, meta=None):
    cur.execute(
        "INSERT INTO lesson_question_options (question_id, option_text, image_url, "
        "audio_url, is_correct, order_index, metadata_json) VALUES (%s,%s,%s,NULL,%s,%s,%s)",
        (qid, text, image, correct, order_index,
         json.dumps(meta, ensure_ascii=False) if meta else None),
    )


def rj(word):
    return ROMAJI.get(word)


def mcq_to_vn(lesson_id, jp, correct_vn, distractors_vn):
    """De bai tieng Nhat (co audio), dap an tieng Viet."""
    qid = insert_question(lesson_id, "TRANSLATE_TO_VN", {"kana": jp, "romaji": rj(jp)})
    attach_audio(qid, jp, "TRANSLATE_TO_VN")
    items = [(correct_vn, True)] + [(d, False) for d in distractors_vn]
    random.shuffle(items)
    for i, (label, is_c) in enumerate(items, start=1):
        insert_option(qid, label, is_c, i)
    return qid


def mcq_to_jp(lesson_id, vn, correct_jp, distractors_jp):
    """De bai tieng Viet (khong audio), dap an tieng Nhat kem romaji (FE tu doc khi cham)."""
    qid = insert_question(lesson_id, "TRANSLATE_TO_JP", {"vn": vn})
    items = [(correct_jp, True)] + [(d, False) for d in distractors_jp]
    random.shuffle(items)
    for i, (label, is_c) in enumerate(items, start=1):
        insert_option(qid, label, is_c, i, meta={"romaji": rj(label)} if rj(label) else None)
    return qid


def listen_select(lesson_id, correct_jp, distractors_jp):
    """Nghe roi chon chu dung -- audio la de bai."""
    qid = insert_question(lesson_id, "LISTEN_AND_SELECT", None)
    attach_audio(qid, correct_jp, "LISTEN_AND_SELECT")
    items = [(correct_jp, True)] + [(d, False) for d in distractors_jp]
    random.shuffle(items)
    for i, (label, is_c) in enumerate(items, start=1):
        insert_option(qid, label, is_c, i, meta={"romaji": rj(label)} if rj(label) else None)
    return qid


def select_image(lesson_id, correct_word, distractor_words):
    """Nghe/doc tu -> chon dung hinh (chi dung lai icon co san)."""
    qid = insert_question(lesson_id, "SELECT_IMAGE",
                           {"kana": correct_word, "romaji": rj(correct_word)})
    attach_audio(qid, correct_word, "SELECT_IMAGE")
    items = [(correct_word, True)] + [(w, False) for w in distractor_words]
    random.shuffle(items)
    for i, (w, is_c) in enumerate(items, start=1):
        insert_option(qid, None, is_c, i, image=IMG[w], meta={"label": w})
    return qid


def arrange(lesson_id, vn_prompt, blocks, spoken_text, distractor_blocks=None):
    qid = insert_question(lesson_id, "LISTEN_AND_ARRANGE", {"vn": vn_prompt})
    attach_audio(qid, spoken_text, "LISTEN_AND_ARRANGE")
    idx = 1
    for b in blocks:
        insert_option(qid, b, True, idx, meta={"romaji": rj(b)} if rj(b) else None)
        idx += 1
    for b in (distractor_blocks or []):
        insert_option(qid, b, False, idx, meta={"romaji": rj(b)} if rj(b) else None)
        idx += 1
    return qid


def speaking(lesson_id, jp, vn):
    qid = insert_question(lesson_id, "SPEAKING", {"kana": jp, "romaji": rj(jp), "vn": vn})
    attach_audio(qid, jp, "SPEAKING")
    insert_option(qid, jp, True, 1, meta={"romaji": rj(jp)})
    return qid


# ===========================================================================
# TOPIC 1: Loi chao, tam biet -- 50 cau moi (10 + 8*5)
# ===========================================================================
def build_topic1():
    L = TOPIC1
    # ---- L1: chi dung lai 5 tu da hoc (おはよう こんにちは こんばんは さようなら またね) ----
    select_image(L["L1"], "こんにちは", ["おはよう", "こんばんは", "さようなら"])
    select_image(L["L1"], "こんばんは", ["さようなら", "おはよう", "こんにちは"])
    select_image(L["L1"], "おはよう", ["こんばんは", "こんにちは", "さようなら"])
    mcq_to_vn(L["L1"], "さようなら", "Tạm biệt",
              ["Chào buổi tối", "Hẹn gặp lại", "Chào buổi trưa"])
    mcq_to_jp(L["L1"], "Chào buổi sáng", "おはよう", ["こんにちは", "こんばんは", "さようなら"])
    mcq_to_jp(L["L1"], "Hẹn gặp lại (thân mật)", "またね", ["さようなら", "おはよう", "こんにちは"])
    listen_select(L["L1"], "こんばんは", ["こんにちは", "おはよう", "さようなら"])
    listen_select(L["L1"], "さようなら", ["またね", "こんばんは", "おはよう"])
    mcq_to_vn(L["L1"], "こんにちは", "Chào buổi trưa",
              ["Chào buổi sáng", "Chào buổi tối", "Tạm biệt"])
    speaking(L["L1"], "またね", "Hẹn gặp lại (thân mật)")

    # ---- L2: them はじめまして / よろしくお願いします / 名前 ----
    mcq_to_vn(L["L2"], "はじめまして", "Rất vui được gặp bạn (lần đầu gặp)",
              ["Lâu rồi không gặp", "Chào buổi sáng (lịch sự)", "Xin phép, tôi xin cáo lui"])
    mcq_to_jp(L["L2"], "Mong được giúp đỡ / Rất hân hạnh", "よろしくお願いします",
              ["はじめまして", "また明日", "お休みなさい"])
    arrange(L["L2"], "Rất vui được gặp bạn, mong được giúp đỡ",
            ["はじめまして", "よろしく", "お願いします"],
            "はじめまして。よろしくお願いします。",
            distractor_blocks=["じゃあね"])
    mcq_to_vn(L["L2"], "名前", "Tên", ["Sáng", "Tối", "Ngày mai"])
    mcq_to_jp(L["L2"], "Tên bạn là gì?", "お名前は？", ["よろしくお願いします", "はじめまして", "お休みなさい"])
    listen_select(L["L2"], "はじめまして", ["じゃあね", "また明日", "お休みなさい"])
    mcq_to_jp(L["L2"], "Hẹn gặp lại ngày mai!", "また明日", ["またね", "じゃあね", "お休みなさい"])
    speaking(L["L2"], "はじめまして。よろしくお願いします。", "Rất vui được gặp bạn, mong được giúp đỡ")

    # ---- L3: them お久しぶりです / 気をつけてね ----
    mcq_to_vn(L["L3"], "お久しぶりです", "Lâu rồi không gặp",
              ["Con về rồi", "Con đi đây", "Chào mừng về nhà"])
    mcq_to_jp(L["L3"], "Lâu quá không gặp bạn!", "お久しぶりです",
              ["ただいま", "いってきます", "失礼します"])
    listen_select(L["L3"], "お久しぶりです", ["いってらっしゃい", "おかえりなさい", "ただいま"])
    mcq_to_vn(L["L3"], "気をつけてね", "Cẩn thận nhé / đi đường an toàn nhé",
              ["Con về rồi", "Chào mừng về nhà", "Xin phép, tôi xin cáo lui"])
    mcq_to_jp(L["L3"], "Cẩn thận nhé!", "気をつけてね",
              ["いってらっしゃい", "おかえりなさい", "ただいま"])
    arrange(L["L3"], "Cẩn thận nhé", ["気を", "つけて", "ね"],
            "気をつけてね。", distractor_blocks=["ただいま"])
    mcq_to_vn(L["L3"], "ただいま", "Con về rồi (khi về đến nhà)",
              ["Chào mừng về nhà", "Con đi đây", "Cẩn thận nhé"])
    mcq_to_jp(L["L3"], "Xin phép, tôi xin cáo lui (trang trọng)", "失礼します",
              ["お久しぶりです", "気をつけてね", "おかえりなさい"])

    # ---- L4: them 乾杯 / ごちそうさま (dang ngan) ----
    mcq_to_vn(L["L4"], "乾杯", "Cạn ly! (nói khi bắt đầu uống cùng nhau)",
              ["Mời dùng bữa", "Cảm ơn vì bữa ăn", "Cảm ơn vì đã vất vả"])
    mcq_to_jp(L["L4"], "Cạn ly!", "乾杯",
              ["いただきます", "ごちそうさまでした", "お疲れ様です"])
    speaking(L["L4"], "乾杯！", "Cạn ly!")
    listen_select(L["L4"], "乾杯", ["いただきます", "お疲れ様です", "お先に失礼します"])
    mcq_to_vn(L["L4"], "ごちそうさま", "Cảm ơn vì bữa ăn (thân mật, ngắn gọn)",
              ["Mời dùng bữa (trước khi ăn)", "Cạn ly!", "Xin phép tôi về trước"])
    mcq_to_jp(L["L4"], "Cảm ơn vì bữa ăn (nói ngắn gọn, thân mật)", "ごちそうさま",
              ["いただきます", "乾杯", "お疲れ様です"])
    mcq_to_vn(L["L4"], "いただきます", "Mời (mọi người) dùng bữa — nói trước khi ăn",
              ["Cảm ơn vì bữa ăn — nói sau khi ăn", "Cạn ly!", "Cảm ơn vì đã vất vả"])
    mcq_to_jp(L["L4"], "Xin phép tôi về trước", "お先に失礼します",
              ["失礼します", "お疲れ様です", "ごちそうさま"])

    # ---- L5: them 大丈夫です / どうですか ----
    mcq_to_vn(L["L5"], "大丈夫です", "Tôi ổn / không sao",
              ["Bạn khoẻ không?", "Cũng tạm ổn", "Tôi khoẻ"])
    mcq_to_jp(L["L5"], "Tôi không sao.", "大丈夫です",
              ["元気です", "まあまあです", "お元気ですか"])
    listen_select(L["L5"], "大丈夫です", ["元気です", "まあまあです", "お元気ですか"])
    mcq_to_vn(L["L5"], "どうですか", "Thế nào? / Bạn thấy sao?",
              ["Bạn khoẻ không?", "Tôi ổn", "Cũng tạm ổn"])
    mcq_to_jp(L["L5"], "Thế nào?", "どうですか",
              ["お元気ですか", "大丈夫です", "まあまあです"])
    arrange(L["L5"], "Bạn khoẻ không? Tôi ổn.", ["お元気ですか", "大丈夫です"],
            "お元気ですか。大丈夫です。", distractor_blocks=["まあまあです"])
    mcq_to_vn(L["L5"], "まあまあです", "Cũng tạm ổn",
              ["Tôi ổn", "Bạn khoẻ không?", "Thế nào?"])
    speaking(L["L5"], "大丈夫です。", "Tôi ổn / không sao")

    # ---- L6: on tap tong hop, khong tu moi ----
    mcq_to_vn(L["L6"], "はじめまして。よろしくお願いします。",
              "Rất vui được gặp bạn. Mong được giúp đỡ.",
              ["Lâu quá không gặp. Bạn khoẻ không?", "Con về rồi. Chào mừng về nhà.",
               "Chúc ngủ ngon. Hẹn gặp ngày mai."])
    mcq_to_jp(L["L6"], "Lâu quá không gặp! Bạn khoẻ không?", "お久しぶりです。お元気ですか。",
              ["はじめまして。よろしくお願いします。", "ただいま。おかえりなさい。",
               "いただきます。ごちそうさま。"])
    arrange(L["L6"], "Cẩn thận nhé", ["気を", "つけて", "ね"],
            "気をつけてね。", distractor_blocks=["いって", "きます"])
    mcq_to_vn(L["L6"], "乾杯", "Cạn ly! (nói khi bắt đầu uống cùng nhau)",
              ["Cảm ơn vì bữa ăn (thân mật)", "Mời dùng bữa", "Cảm ơn vì đã vất vả"])
    speaking(L["L6"], "お久しぶりです。", "Lâu rồi không gặp")
    mcq_to_jp(L["L6"], "Tôi không sao.", "大丈夫です", ["まあまあです", "元気です", "どうですか"])
    listen_select(L["L6"], "じゃあね", ["またね", "また明日", "お休みなさい"])
    mcq_to_vn(L["L6"], "いただきます。ごちそうさま。",
              "Mời dùng bữa. Cảm ơn vì bữa ăn (thân mật).",
              ["Cạn ly! Chúc ngon miệng.", "Con đi đây. Cẩn thận nhé.",
               "Xin phép tôi về trước. Hẹn gặp lại."])


# ===========================================================================
# TOPIC 2: Goi do an, do uong -- 50 cau moi (10 + 8*5)
# ===========================================================================
def build_topic2():
    L = TOPIC2
    # ---- L1: chi dung lai 5 tu da hoc (お茶 ご飯 水 パン コーヒー) ----
    select_image(L["L1"], "ご飯", ["お茶", "水", "パン"])
    select_image(L["L1"], "パン", ["コーヒー", "ご飯", "水"])
    select_image(L["L1"], "コーヒー", ["お茶", "水", "パン"])
    mcq_to_vn(L["L1"], "水", "Nước", ["Trà", "Cà phê", "Bánh mì"])
    mcq_to_jp(L["L1"], "Bánh mì", "パン", ["水", "お茶", "コーヒー"])
    listen_select(L["L1"], "コーヒー", ["お茶", "水", "ご飯"])
    listen_select(L["L1"], "ご飯", ["パン", "水", "お茶"])
    arrange(L["L1"], "Nước và bánh mì", ["水", "と", "パン"],
            "水とパン。", distractor_blocks=["ご飯"])
    mcq_to_vn(L["L1"], "パン", "Bánh mì", ["Cà phê", "Trà", "Cơm"])
    speaking(L["L1"], "ご飯", "Cơm")

    # ---- L2: them ビール / おいしいです ----
    mcq_to_vn(L["L2"], "ビール", "Bia", ["Nước ép/nước ngọt", "Trà", "Cà phê"])
    mcq_to_jp(L["L2"], "Cho tôi xin bia.", "ビールをください",
              ["お茶をください", "水をください", "ジュースをください"])
    arrange(L["L2"], "Cho tôi bia", ["ビール", "を", "ください"],
            "ビールをください。", distractor_blocks=["水"])
    mcq_to_vn(L["L2"], "おいしいです", "Ngon", ["Bao nhiêu tiền?", "Xin lỗi", "Làm ơn"])
    mcq_to_jp(L["L2"], "Ngon quá!", "おいしいです", ["すみません", "お願いします", "いくらですか"])
    listen_select(L["L2"], "ビール", ["ジュース", "お茶", "コーヒー"])
    mcq_to_vn(L["L2"], "寿司", "Sushi", ["Ramen", "Thịt", "Bia"])
    mcq_to_jp(L["L2"], "Cho tôi xin cá.", "魚をください",
              ["肉をください", "寿司をください", "ビールをください"])

    # ---- L3: them ケーキ / アイス ----
    mcq_to_vn(L["L3"], "ケーキ", "Bánh ngọt / bánh kem", ["Rau", "Trứng", "Ramen"])
    mcq_to_jp(L["L3"], "Cho tôi bánh ngọt (lịch sự).", "ケーキをお願いします",
              ["ラーメンをお願いします", "卵をお願いします", "水をお願いします"])
    arrange(L["L3"], "Cho tôi bánh ngọt (lịch sự)", ["ケーキ", "を", "お願いします"],
            "ケーキをお願いします。", distractor_blocks=["野菜"])
    mcq_to_vn(L["L3"], "アイス", "Kem", ["Bia", "Bánh ngọt", "Nước ép/nước ngọt"])
    mcq_to_jp(L["L3"], "Kem", "アイス", ["ケーキ", "ビール", "メニュー"])
    listen_select(L["L3"], "ケーキ", ["アイス", "メニュー", "ラーメン"])
    mcq_to_vn(L["L3"], "野菜", "Rau", ["Trứng", "Cá", "Ramen"])
    mcq_to_jp(L["L3"], "Trứng", "卵", ["野菜", "肉", "ラーメン"])

    # ---- L4: them とても (+ おいしい ket hop) ----
    mcq_to_vn(L["L4"], "とてもおいしいです", "Rất ngon",
              ["Bao nhiêu tiền?", "Cho tôi tính tiền.", "Cho tôi đặt món."])
    mcq_to_jp(L["L4"], "Rất ngon!", "とてもおいしいです",
              ["おいしいです", "とても", "お会計をお願いします"])
    arrange(L["L4"], "Rất ngon", ["とても", "おいしい", "です"],
            "とてもおいしいです。", distractor_blocks=["すみません"])
    mcq_to_vn(L["L4"], "これはいくらですか", "Cái này bao nhiêu tiền?",
              ["Cho tôi xem thực đơn.", "Cho tôi tính tiền.", "Tôi muốn đặt món."])
    mcq_to_jp(L["L4"], "Xin lỗi, cái này bao nhiêu tiền?", "すみません、これはいくらですか。",
              ["すみません、メニューをください。", "お会計をお願いします。",
               "これはとてもおいしいです。"])
    listen_select(L["L4"], "とてもおいしいです", ["おいしいです", "いくらですか", "お願いします"])
    mcq_to_vn(L["L4"], "注文", "Gọi món / đặt hàng", ["Tính tiền", "Thực đơn", "Xin lỗi"])
    mcq_to_jp(L["L4"], "Cho tôi tính tiền.", "お会計をお願いします",
              ["注文をお願いします", "メニューをお願いします", "水をお願いします"])

    # ---- L5: them 一つ / 二つ ----
    mcq_to_vn(L["L5"], "一つ", "Một cái/phần", ["Hai cái/phần", "Rất", "Ngon"])
    mcq_to_jp(L["L5"], "Cho tôi một phần cơm.", "ご飯を一つください",
              ["ご飯をください", "パンを一つください", "水を一つください"])
    arrange(L["L5"], "Cho tôi một phần cơm", ["ご飯", "を", "一つ", "ください"],
            "ご飯を一つください。", distractor_blocks=["二つ"])
    mcq_to_vn(L["L5"], "二つ", "Hai cái/phần", ["Một cái/phần", "Rất", "Kem"])
    mcq_to_jp(L["L5"], "Cho tôi hai phần ramen.", "ラーメンを二つください",
              ["ラーメンを一つください", "寿司を二つください", "水を二つください"])
    listen_select(L["L5"], "一つ", ["二つ", "とても", "アイス"])
    mcq_to_vn(L["L5"], "ラーメンと野菜をお願いします", "Cho tôi ramen và rau.",
              ["Cho tôi trứng và nước.", "Cho tôi thịt và cơm.", "Cho tôi trà và cà phê."])
    mcq_to_jp(L["L5"], "Cho tôi trà và sushi.", "お茶と寿司をください",
              ["ご飯と魚をください", "肉と卵をください", "パンとコーヒーをください"])

    # ---- L6: on tap tong hop, khong tu moi (アイスコーヒー la tu ghep tu 2 tu da biet) ----
    mcq_to_vn(L["L6"], "ビールをください。とてもおいしいです。",
              "Cho tôi xin bia. Rất ngon.",
              ["Cho tôi xin nước. Cũng được.", "Cho tôi tính tiền. Cảm ơn.",
               "Cho tôi xem thực đơn. Được không?"])
    mcq_to_jp(L["L6"], "Cho tôi một phần bánh ngọt.", "ケーキを一つください",
              ["ケーキを二つください", "アイスを一つください", "ケーキをお願いします"])
    arrange(L["L6"], "Cho tôi hai cái bánh ngọt", ["ケーキ", "を", "二つ", "ください"],
            "ケーキを二つください。", distractor_blocks=["一つ"])
    mcq_to_vn(L["L6"], "アイスコーヒー", "Cà phê đá",
              ["Cà phê nóng", "Trà đá", "Nước ép"])
    speaking(L["L6"], "とてもおいしいです。", "Rất ngon")
    mcq_to_jp(L["L6"], "Cho tôi trứng và rau.", "卵と野菜をください",
              ["肉と魚をください", "ラーメンと野菜をお願いします", "お茶とご飯をください"])
    listen_select(L["L6"], "ケーキ", ["アイス", "ビール", "ジュース"])
    mcq_to_vn(L["L6"], "すみません、お会計をお願いします。",
              "Xin lỗi, cho tôi tính tiền.",
              ["Xin lỗi, cho tôi xem thực đơn.", "Cho tôi tính tiền.",
               "Cái này bao nhiêu tiền?"])


# ===========================================================================
# Sinh audio that (edge-tts) cho nhung cau con thieu
# ===========================================================================
async def build_audio():
    import edge_tts

    os.makedirs(AUDIO_DIR, exist_ok=True)
    sem = asyncio.Semaphore(6)
    done = [0]
    failed = []

    async def one(qid, text):
        path = os.path.join(AUDIO_DIR, "q_%d.mp3" % qid)
        async with sem:
            for attempt in range(3):
                try:
                    c = edge_tts.Communicate(text, VOICE, rate="-10%")
                    await c.save(path)
                    if os.path.getsize(path) > 500:
                        done[0] += 1
                        return
                except Exception as e:  # noqa: BLE001
                    if attempt == 2:
                        failed.append((qid, text, str(e)[:120]))
                    await asyncio.sleep(1.5 * (attempt + 1))

    print("AM THANH: can sinh %d file moi" % len(pending_audio))
    await asyncio.gather(*[one(qid, text) for qid, text in pending_audio])
    print("AM THANH: thanh cong %d, that bai %d" % (done[0], len(failed)))
    for qid, text, err in failed[:10]:
        print("   LOI q_%d (%s): %s" % (qid, text, err))
    return failed


def main():
    preload_audio_cache()

    cur.execute(
        "SELECT COUNT(*) FROM lesson_questions WHERE lesson_id IN (%s)"
        % ",".join(str(x) for x in list(TOPIC1.values()) + list(TOPIC2.values()))
    )
    before = cur.fetchone()[0]

    build_topic1()
    build_topic2()

    cur.execute(
        "SELECT COUNT(*) FROM lesson_questions WHERE lesson_id IN (%s)"
        % ",".join(str(x) for x in list(TOPIC1.values()) + list(TOPIC2.values()))
    )
    after = cur.fetchone()[0]
    print("Cau hoi truoc: %d, sau: %d (them %d)" % (before, after, after - before))
    print("Can sinh audio moi cho %d cau (phan con lai tai su dung file cu)"
          % len(pending_audio))

    conn.commit()
    print("Da COMMIT du lieu vao DB.")

    if pending_audio:
        failed = asyncio.run(build_audio())
        if failed:
            print("CANH BAO: %d file audio that bai, kiem tra lai thu cong." % len(failed))


if __name__ == "__main__":
    if "--audio-only" in sys.argv:
        asyncio.run(build_audio())
    else:
        main()
    cur.close()
    conn.close()
