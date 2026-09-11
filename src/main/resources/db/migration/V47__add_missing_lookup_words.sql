-- Bổ sung các TỪ ĐƠN còn thiếu trong kho tra nghĩa tại chỗ.
--
-- Vì sao cần: tính năng bấm-tra-nghĩa tách câu bằng cách khớp chuỗi với bảng
-- `vocabulary`. Chữ nào không có trong bảng thì thành chữ thường, không bấm được,
-- VÀ nó chặn luôn việc tách câu thành từng từ (bộ tách chỉ chấp nhận kết quả khi
-- mọi khe hở còn lại là trợ từ hiragana ngắn). Điển hình: 「また明日」 không tách
-- được vì dạng chữ Hán 「明日」 chưa từng có trong bảng — chỉ có 「あした」.
--
-- Danh sách dưới đây lấy từ việc đo trên 611 đề bài tiếng Nhật thật: đây đúng là
-- những mảnh chữ không tra được. Các mảnh còn lại là đuôi ngữ pháp (ですか, ですね,
-- のです...) nên CỐ Ý không thêm — chúng là ngữ pháp, không phải từ vựng.
--
-- Toàn bộ là từ mức N5, chỉ phục vụ tra nghĩa: không gắn vào câu hỏi nào
-- (`question_vocabulary`) nên không đụng tới lộ trình học hay lịch ôn SM-2.
-- INSERT IGNORE để chạy lại nhiều lần vẫn an toàn (khoá duy nhất: item_type + surface).

INSERT IGNORE INTO vocabulary (item_type, surface, reading, romaji, meaning_vn, jlpt_level) VALUES
  -- Dạng chữ Hán của những từ vốn chỉ có dạng kana trong bảng
  ('VOCAB', '明日',   'あした',       'ashita',       'ngày mai',            'N5'),
  ('VOCAB', 'お休み', 'おやすみ',     'oyasumi',      'chúc ngủ ngon; nghỉ', 'N5'),
  ('VOCAB', 'お願い', 'おねがい',     'onegai',       'làm ơn, xin nhờ',     'N5'),
  ('VOCAB', '元気',   'げんき',       'genki',        'khỏe mạnh',           'N5'),
  -- Từ chưa từng có trong bảng
  ('VOCAB', 'お元気', 'おげんき',     'ogenki',       'khỏe mạnh (lịch sự)', 'N5'),
  ('VOCAB', '失礼',   'しつれい',     'shitsurei',    'thất lễ, bất lịch sự','N5'),
  ('VOCAB', 'お先に', 'おさきに',     'osakini',      'xin phép trước',      'N5'),
  ('VOCAB', 'お疲れ様','おつかれさま', 'otsukaresama', 'vất vả rồi',          'N5'),
  ('VOCAB', 'お会計', 'おかいけい',   'okaikei',      'tính tiền, hoá đơn',  'N5'),
  ('VOCAB', 'まあまあ', NULL,         'maamaa',       'tàm tạm',             'N5'),
  ('VOCAB', 'アイス',  NULL,          'aisu',         'kem',                 'N5'),
  ('VOCAB', 'ケーキ',  NULL,          'keeki',        'bánh ngọt',           'N5');
