# -*- coding: utf-8 -*-
"""
Gan audio_url THAT (mp3 that, khong phai TTS may) cho TUNG dap an tieng Nhat
co the bam vao trong topic 1 & 2 (ca cau cu lan 100 cau moi vua them):

  - TRANSLATE_TO_JP  : 4 dap an la chu Nhat -> can audio.
  - LISTEN_AND_SELECT: 4 dap an la chu Nhat -> can audio.
  - LISTEN_AND_ARRANGE: cac khoi tu (block) la chu Nhat -> can audio.
  - SELECT_IMAGE     : dap an la ANH, chu that giau trong metadata_json.label
                       -> can audio cho tung label.
  - TRANSLATE_TO_VN  : dap an la TIENG VIET -> KHONG can audio (khong co gi
                       de doc bang tieng Nhat).

Tai su dung file da co (tu cache dung o lan chay truoc + audio cap do CAU
HOI da co san) neu trung noi dung -- khong sinh trung lap. File moi dat ten
"a_<option_id>.mp3" (tien to "a_" phan biet voi "q_<question_id>.mp3" cua
cau hoi) trong CUNG thu muc uploads/audios/questions (da duoc BE serve san,
khong can sua config).

Chay: python add_option_audio.py
"""
import asyncio
import json
import os

import pymysql

DB = dict(host="127.0.0.1", port=3307, user="nihongo_user", password="1234",
          database="nihongo_db", charset="utf8mb4")

BASE = os.path.dirname(os.path.abspath(__file__))
UPLOADS = os.path.abspath(os.path.join(BASE, "..", "..", "uploads"))
AUDIO_DIR = os.path.join(UPLOADS, "audios", "questions")
VOICE = "ja-JP-NanamiNeural"

LESSON_IDS = [149, 150, 151, 152, 153, 154, 157, 158, 159, 160, 161, 162]

conn = pymysql.connect(**DB)
cur = conn.cursor()

audio_cache = {}     # text tieng Nhat -> url mp3 co san
pending = []          # [(option_id, text)]


def is_japanese(s):
    if not s:
        return False
    return any(
        "぀" <= c <= "ヿ" or "一" <= c <= "鿿"
        for c in s
    )


def preload_cache():
    fmt = ",".join(["%s"] * len(LESSON_IDS))
    # 1) audio cap do CAU HOI da co (tu lan sinh truoc + du lieu goc V44)
    cur.execute(
        "SELECT q.id, q.metadata_json, q.audio_url, "
        "(SELECT o.option_text FROM lesson_question_options o "
        " WHERE o.question_id=q.id AND o.is_correct=1 ORDER BY o.order_index LIMIT 1) "
        f"FROM lesson_questions q WHERE q.audio_url IS NOT NULL AND q.lesson_id IN ({fmt})",
        LESSON_IDS,
    )
    for qid, meta, url, correct_opt in cur.fetchall():
        m = json.loads(meta) if meta else {}
        text = m.get("kana") or m.get("jp") or correct_opt
        if text and text not in audio_cache:
            audio_cache[text] = url

    # 2) audio cap do DAP AN da co san tu truoc (neu co, phong khi chay lai script)
    cur.execute(
        "SELECT o.option_text, o.metadata_json, o.audio_url "
        f"FROM lesson_question_options o "
        f"JOIN lesson_questions q ON q.id=o.question_id "
        f"WHERE o.audio_url IS NOT NULL AND q.lesson_id IN ({fmt})",
        LESSON_IDS,
    )
    for text, meta, url in cur.fetchall():
        m = json.loads(meta) if meta else {}
        t = text or m.get("label")
        if t and t not in audio_cache:
            audio_cache[t] = url

    print("Cache: %d muc audio co san de tai su dung" % len(audio_cache))


def collect_targets():
    """Tra ve list (option_id, spoken_text) can gan audio, bo qua neu da co."""
    fmt = ",".join(["%s"] * len(LESSON_IDS))
    cur.execute(
        "SELECT o.id, o.option_text, o.metadata_json, o.audio_url, q.question_type "
        f"FROM lesson_question_options o "
        f"JOIN lesson_questions q ON q.id=o.question_id "
        f"WHERE q.lesson_id IN ({fmt}) "
        "AND q.question_type IN ('TRANSLATE_TO_JP','LISTEN_AND_SELECT',"
        "'LISTEN_AND_ARRANGE','SELECT_IMAGE')",
        LESSON_IDS,
    )
    targets = []
    for oid, text, meta, existing_url, qtype in cur.fetchall():
        if existing_url:
            continue
        m = json.loads(meta) if meta else {}
        spoken = text if is_japanese(text) else (m.get("label") if is_japanese(m.get("label")) else None)
        if not spoken:
            continue
        targets.append((oid, spoken))
    return targets


def assign_audio(targets):
    updates = []  # (option_id, url)
    for oid, text in targets:
        cached = audio_cache.get(text)
        if cached:
            updates.append((oid, cached))
            continue
        url = "/uploads/audios/questions/a_%d.mp3" % oid
        audio_cache[text] = url
        updates.append((oid, url))
        pending.append((oid, text))

    for oid, url in updates:
        cur.execute("UPDATE lesson_question_options SET audio_url=%s WHERE id=%s", (url, oid))
    return len(updates)


async def build_audio():
    import edge_tts

    os.makedirs(AUDIO_DIR, exist_ok=True)
    sem = asyncio.Semaphore(6)
    done = [0]
    failed = []

    async def one(oid, text):
        path = os.path.join(AUDIO_DIR, "a_%d.mp3" % oid)
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
                        failed.append((oid, text, str(e)[:120]))
                    await asyncio.sleep(1.5 * (attempt + 1))

    print("AM THANH DAP AN: can sinh %d file moi" % len(pending))
    await asyncio.gather(*[one(oid, text) for oid, text in pending])
    print("AM THANH DAP AN: thanh cong %d, that bai %d" % (done[0], len(failed)))
    for oid, text, err in failed[:10]:
        print("   LOI a_%d (%s): %s" % (oid, text, err))
    return failed


def main():
    preload_cache()
    targets = collect_targets()
    print("Dap an can gan audio_url: %d" % len(targets))
    n_updated = assign_audio(targets)
    print("Da UPDATE %d dong (%d tai su dung file cu, %d can sinh moi)"
          % (n_updated, n_updated - len(pending), len(pending)))
    conn.commit()
    print("Da COMMIT.")

    if pending:
        failed = asyncio.run(build_audio())
        if failed:
            print("CANH BAO: %d file that bai, kiem tra lai." % len(failed))


if __name__ == "__main__":
    main()
    cur.close()
    conn.close()
