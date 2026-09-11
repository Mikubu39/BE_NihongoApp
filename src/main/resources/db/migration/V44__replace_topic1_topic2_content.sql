-- Xoá toàn bộ lesson/question/option cũ của topic 1 và 2 (cascade qua FK).
-- Dữ liệu cũ đã được backup ra file SQL trước khi chạy migration này
-- (xem backups/backup_before_topic1_2_replace.sql).
DELETE FROM lessons WHERE topic_id IN (1, 2);

-- =====================================================================
-- Topic 1: Lời chào, tạm biệt
-- =====================================================================
UPDATE topics SET title = 'Lời chào, tạm biệt', description = 'Học cách chào hỏi, hỏi thăm và tạm biệt trong các tình huống hằng ngày.' WHERE id = 1;

-- Lesson: Bài 1: Chào cơ bản
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Bài 1: Chào cơ bản', 1, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'おはよう', 'romaji', 'ohayou'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_ohayou.png', NULL, TRUE, 1, JSON_OBJECT('label', 'おはよう')),
  (@q, NULL, '/uploads/images/vocab_konnichiwa.png', NULL, FALSE, 2, JSON_OBJECT('label', 'こんにちは')),
  (@q, NULL, '/uploads/images/vocab_konbanwa.png', NULL, FALSE, 3, JSON_OBJECT('label', 'こんばんは')),
  (@q, NULL, '/uploads/images/vocab_sayounara.png', NULL, FALSE, 4, JSON_OBJECT('label', 'さようなら'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'こんにちは', 'romaji', 'konnichiwa'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_konbanwa.png', NULL, FALSE, 1, JSON_OBJECT('label', 'こんばんは')),
  (@q, NULL, '/uploads/images/vocab_konnichiwa.png', NULL, TRUE, 2, JSON_OBJECT('label', 'こんにちは')),
  (@q, NULL, '/uploads/images/vocab_ohayou.png', NULL, FALSE, 3, JSON_OBJECT('label', 'おはよう')),
  (@q, NULL, '/uploads/images/vocab_sayounara.png', NULL, FALSE, 4, JSON_OBJECT('label', 'さようなら'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'こんばんは', 'romaji', 'konbanwa'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_sayounara.png', NULL, FALSE, 1, JSON_OBJECT('label', 'さようなら')),
  (@q, NULL, '/uploads/images/vocab_ohayou.png', NULL, FALSE, 2, JSON_OBJECT('label', 'おはよう')),
  (@q, NULL, '/uploads/images/vocab_konbanwa.png', NULL, TRUE, 3, JSON_OBJECT('label', 'こんばんは')),
  (@q, NULL, '/uploads/images/vocab_konnichiwa.png', NULL, FALSE, 4, JSON_OBJECT('label', 'こんにちは'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'さようなら', 'romaji', 'sayounara'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_konnichiwa.png', NULL, FALSE, 1, JSON_OBJECT('label', 'こんにちは')),
  (@q, NULL, '/uploads/images/vocab_sayounara.png', NULL, TRUE, 2, JSON_OBJECT('label', 'さようなら')),
  (@q, NULL, '/uploads/images/vocab_konbanwa.png', NULL, FALSE, 3, JSON_OBJECT('label', 'こんばんは')),
  (@q, NULL, '/uploads/images/vocab_ohayou.png', NULL, FALSE, 4, JSON_OBJECT('label', 'おはよう'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'おはよう', 'romaji', 'ohayou'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chào buổi sáng', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Tạm biệt', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Hẹn gặp lại', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'こんばんは', 'romaji', 'konbanwa'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chào buổi tối', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Tạm biệt', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào (buổi trưa)', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Tạm biệt'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おはよう', NULL, NULL, FALSE, 1, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'konnichiwa')),
  (@q, 'さようなら', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'sayounara')),
  (@q, 'こんばんは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konbanwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào (buổi trưa)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'こんにちは', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'konnichiwa')),
  (@q, 'おはよう', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'こんばんは', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'konbanwa')),
  (@q, 'さようなら', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sayounara'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'こんにちは', NULL, NULL, FALSE, 1, JSON_OBJECT('romaji', 'konnichiwa')),
  (@q, 'またね', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'mata ne')),
  (@q, 'さようなら', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'sayounara')),
  (@q, 'おはよう', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'ohayou'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'またね', 'romaji', 'mata ne'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Hẹn gặp lại (thân mật)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tạm biệt (trang trọng)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 4, NULL);

-- Lesson: Bài 2: Chào theo buổi & tạm biệt thân mật
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Bài 2: Chào theo buổi & tạm biệt thân mật', 2, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'おはようございます', 'romaji', 'ohayou gozaimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chào buổi sáng (lịch sự)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi sáng (thân mật)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Tạm biệt', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào buổi sáng (lịch sự, dùng với người lớn tuổi/cấp trên)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おはようございます', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ohayou gozaimasu')),
  (@q, 'おはよう', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'こんばんは', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'konbanwa')),
  (@q, 'さようなら', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sayounara'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào buổi sáng (lịch sự)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おはよう', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'ございます', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'gozaimasu')),
  (@q, 'こんばんは', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'konbanwa')),
  (@q, 'さようなら', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sayounara'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'また明日', 'romaji', 'mata ashita'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Hẹn gặp lại vào ngày mai', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Hẹn gặp lại (thân mật)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chúc ngủ ngon', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Tạm biệt nhé', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Hẹn gặp lại ngày mai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'また明日', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'mata ashita')),
  (@q, 'またね', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'mata ne')),
  (@q, 'さようなら', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'sayounara')),
  (@q, 'お休みなさい', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'oyasuminasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'じゃあね', 'romaji', 'jaa ne'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Tạm biệt nhé (rất thân mật)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tạm biệt (trang trọng)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Hẹn gặp lại ngày mai', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'じゃあね', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'jaa ne')),
  (@q, 'またね', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'mata ne')),
  (@q, 'さようなら', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'sayounara')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konnichiwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お休みなさい', 'romaji', 'oyasuminasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chúc ngủ ngon', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Hẹn gặp lại ngày mai', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Tạm biệt', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chúc ngủ ngon'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お休みなさい', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'oyasuminasai')),
  (@q, 'おはようございます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ohayou gozaimasu')),
  (@q, 'また明日', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'mata ashita')),
  (@q, 'じゃあね', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'jaa ne'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Hẹn gặp lại vào ngày mai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'また', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'mata')),
  (@q, '明日', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'ashita')),
  (@q, 'ございます', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gozaimasu')),
  (@q, 'ね', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'ne'));

-- Lesson: Bài 3: Tạm biệt trang trọng, ra vào nhà
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Bài 3: Tạm biệt trang trọng, ra vào nhà', 3, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '失礼します', 'romaji', 'shitsurei shimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin phép, tôi xin cáo lui (trang trọng)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Con về rồi', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Hẹn gặp lại ngày mai', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Xin phép (khi rời cuộc họp/gọi điện)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '失礼します', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'shitsurei shimasu')),
  (@q, 'さようなら', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'sayounara')),
  (@q, 'ただいま', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'おかえりなさい', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'okaerinasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'いってきます', 'romaji', 'itte kimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Con đi đây (khi ra khỏi nhà)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Con về rồi (khi về đến nhà)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Đi đường cẩn thận nhé', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào mừng về nhà', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Đi đường cẩn thận nhé (đáp lại khi ai đó ra khỏi nhà)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'いってらっしゃい', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'itte rasshai')),
  (@q, 'いってきます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itte kimasu')),
  (@q, 'ただいま', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'おかえりなさい', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'okaerinasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'いってきます', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'itte kimasu')),
  (@q, 'いってらっしゃい', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itte rasshai')),
  (@q, 'ただいま', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'おかえりなさい', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'okaerinasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'ただいま', 'romaji', 'tadaima'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Con về rồi (khi về đến nhà)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Con đi đây (khi ra khỏi nhà)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào mừng về nhà', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin phép, tôi xin cáo lui', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Con về rồi'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ただいま', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'おかえりなさい', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'okaerinasai')),
  (@q, 'いってきます', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'itte kimasu')),
  (@q, '失礼します', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'shitsurei shimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'おかえりなさい', 'romaji', 'okaerinasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chào mừng về nhà (đáp lại tadaima)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Con về rồi', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Con đi đây', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Đi đường cẩn thận nhé', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Con đi đây'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'いって', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'itte')),
  (@q, 'きます', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'kimasu')),
  (@q, 'らっしゃい', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'rasshai')),
  (@q, 'ただいま', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'tadaima'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào mừng về nhà'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おかえりなさい', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'okaerinasai')),
  (@q, 'ただいま', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'いってらっしゃい', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'itte rasshai')),
  (@q, '失礼します', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'shitsurei shimasu'));

-- Lesson: Bài 4: Chào trong bữa ăn & nơi làm việc
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Bài 4: Chào trong bữa ăn & nơi làm việc', 4, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'いただきます', 'romaji', 'itadakimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Mời (mọi người) dùng bữa — nói trước khi ăn', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cảm ơn vì bữa ăn — nói sau khi ăn', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Xin phép tôi về trước', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cảm ơn vì đã vất vả', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Nói trước khi bắt đầu ăn'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'いただきます', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'itadakimasu')),
  (@q, 'ごちそうさまでした', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'gochisousama deshita')),
  (@q, 'お疲れ様です', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'otsukaresama desu')),
  (@q, 'お先に失礼します', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'osaki ni shitsurei shimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'ごちそうさまでした', 'romaji', 'gochisousama deshita'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cảm ơn vì bữa ăn — nói sau khi ăn xong', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Mời dùng bữa — nói trước khi ăn', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cảm ơn vì đã vất vả', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin phép tôi về trước', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ごちそうさまでした', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gochisousama deshita')),
  (@q, 'いただきます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itadakimasu')),
  (@q, 'お疲れ様です', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'otsukaresama desu')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konnichiwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Nói sau khi ăn xong'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ごちそうさまでした', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gochisousama deshita')),
  (@q, 'いただきます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itadakimasu')),
  (@q, 'お先に失礼します', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'osaki ni shitsurei shimasu')),
  (@q, 'お疲れ様です', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'otsukaresama desu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お疲れ様です', 'romaji', 'otsukaresama desu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cảm ơn vì đã vất vả (chào khi tan làm/gặp đồng nghiệp)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Mời dùng bữa', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Xin phép tôi về trước', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cảm ơn vì bữa ăn', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào tạm biệt đồng nghiệp sau giờ làm'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お疲れ様です', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'otsukaresama desu')),
  (@q, 'いただきます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itadakimasu')),
  (@q, 'ごちそうさまでした', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gochisousama deshita')),
  (@q, 'おかえりなさい', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'okaerinasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お先に失礼します', 'romaji', 'osaki ni shitsurei shimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin phép tôi về trước', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cảm ơn vì đã vất vả', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Mời dùng bữa', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Con về rồi', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Mời dùng bữa'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'いただき', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'itadaki')),
  (@q, 'ます', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'masu')),
  (@q, 'ごちそうさま', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gochisousama')),
  (@q, 'でした', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'deshita'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cảm ơn vì bữa ăn'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ごちそうさま', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gochisousama')),
  (@q, 'でした', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'deshita')),
  (@q, 'いただき', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'itadaki')),
  (@q, 'ます', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'masu'));

-- Lesson: Bài 5: Hỏi thăm khi chào
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Bài 5: Hỏi thăm khi chào', 5, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お元気ですか', 'romaji', 'ogenki desu ka'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Bạn khoẻ không?', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tôi khoẻ', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cũng tạm ổn', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Bạn khoẻ không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お元気ですか', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ogenki desu ka')),
  (@q, '元気です', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'genki desu')),
  (@q, 'まあまあです', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'maamaa desu')),
  (@q, 'おはよう', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'ohayou'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '元気です', 'romaji', 'genki desu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Tôi khoẻ', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Bạn khoẻ không?', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cũng tạm ổn', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Tạm biệt', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Tôi khoẻ'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '元気です', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'genki desu')),
  (@q, 'お元気ですか', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ogenki desu ka')),
  (@q, 'まあまあです', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'maamaa desu')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konnichiwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'まあまあです', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'maamaa desu')),
  (@q, '元気です', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'genki desu')),
  (@q, 'お元気ですか', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ogenki desu ka')),
  (@q, 'こんばんは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konbanwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'まあまあです', 'romaji', 'maamaa desu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cũng tạm ổn', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tôi khoẻ', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Bạn khoẻ không?', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào buổi sáng, bạn khoẻ không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おはよう', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'お元気ですか', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'ogenki desu ka')),
  (@q, 'こんばんは', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'konbanwa')),
  (@q, 'まあまあです', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'maamaa desu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào buổi sáng. Bạn khoẻ không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おはよう。お元気ですか。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ohayou. ogenki desu ka.')),
  (@q, 'こんばんは。元気です。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'konbanwa. genki desu.')),
  (@q, 'さようなら。またね。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'sayounara. mata ne.')),
  (@q, 'こんにちは。まあまあです。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konnichiwa. maamaa desu.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'こんにちは。元気です。', 'romaji', 'konnichiwa. genki desu.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chào (buổi trưa). Tôi khoẻ.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi tối. Cũng tạm ổn.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào buổi sáng. Bạn khoẻ không?', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Tạm biệt. Hẹn gặp lại.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Bạn khoẻ không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お元気', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ogenki')),
  (@q, 'ですか', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'desu ka')),
  (@q, 'まあまあ', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'maamaa')),
  (@q, 'です', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'desu'));

-- Lesson: Bài 6: Ôn tập tổng hợp - hội thoại chào hỏi
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Bài 6: Ôn tập tổng hợp - hội thoại chào hỏi', 6, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'ただいま。', 'romaji', 'tadaima.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Con/tôi về rồi.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Con đi đây.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào mừng về nhà.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin phép tôi về trước.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào mừng về nhà!'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おかえりなさい。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'okaerinasai.')),
  (@q, 'ただいま。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'tadaima.')),
  (@q, 'いってきます。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'itte kimasu.')),
  (@q, '失礼します。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'shitsurei shimasu.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'いってきます。いってらっしゃい。', 'romaji', 'itte kimasu. itte rasshai.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Con đi đây. / Đi cẩn thận nhé.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Con về rồi. / Chào mừng về nhà.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chúc ngủ ngon. / Hẹn gặp ngày mai.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin lỗi. / Cảm ơn.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SPEAKING', NULL, NULL, NULL, JSON_OBJECT('kana', 'お元気ですか。', 'romaji', 'ogenki desu ka.', 'vn', 'Bạn khoẻ không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お元気ですか。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ogenki desu ka.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Tôi khoẻ.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '元気です。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'genki desu.')),
  (@q, 'まあまあです。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'maamaa desu.')),
  (@q, 'お元気ですか。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ogenki desu ka.')),
  (@q, 'ただいま。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'tadaima.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'こんばんは。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'konbanwa.')),
  (@q, 'おはよう。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ohayou.')),
  (@q, 'こんにちは。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'konnichiwa.')),
  (@q, 'さようなら。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sayounara.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お先に失礼します。', 'romaji', 'osaki ni shitsurei shimasu.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin phép tôi về trước.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Xin phép, tôi xin cáo lui.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cảm ơn vì đã vất vả.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Con đi đây.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cảm ơn vì đã vất vả'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お疲れ様', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'otsukaresama')),
  (@q, 'です', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'desu')),
  (@q, 'ごちそうさま', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gochisousama')),
  (@q, 'でした', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'deshita'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Hẹn gặp lại vào ngày mai!'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'また明日！', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'mata ashita!')),
  (@q, 'またね！', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'mata ne!')),
  (@q, 'じゃあね！', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'jaa ne!')),
  (@q, 'お休みなさい！', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'oyasuminasai!'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'さようなら。またね。', 'romaji', 'sayounara. mata ne.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Tạm biệt. Hẹn gặp lại.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi sáng. Bạn khoẻ không?', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Con về rồi. Chào mừng về nhà.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chúc ngủ ngon. Hẹn gặp ngày mai.', NULL, NULL, FALSE, 4, NULL);

-- Lesson: Ôn tập tốc độ: Lời chào, tạm biệt
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Ôn tập tốc độ: Lời chào, tạm biệt', NULL, 'TIMED_REVIEW', '{"expReward":30,"description":"","replayExpRatio":0.3,"starThresholds":[90,150],"entryCostEnergy":5,"questionsPerSession":12}');
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'こんにちは', 'romaji', 'konnichiwa'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chào (buổi trưa/chiều)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Tạm biệt', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào buổi tối'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'こんばんは', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'konbanwa')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'konnichiwa')),
  (@q, 'おはよう', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'さようなら', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sayounara'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'さようなら', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sayounara')),
  (@q, 'またね', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'mata ne')),
  (@q, 'おはよう', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konnichiwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'おはようございます', 'romaji', 'ohayou gozaimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Chào buổi sáng (lịch sự)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi tối (lịch sự)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Tạm biệt (lịch sự)', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cảm ơn (lịch sự)', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Hẹn gặp ngày mai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'また', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'mata')),
  (@q, '明日', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'ashita')),
  (@q, 'ね', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ne'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chúc ngủ ngon'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お休みなさい', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'oyasuminasai')),
  (@q, 'おはようございます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ohayou gozaimasu')),
  (@q, 'また明日', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'mata ashita')),
  (@q, 'じゃあね', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'jaa ne'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'いってらっしゃい', 'romaji', 'itte rasshai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Đi đường cẩn thận nhé', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Con đi đây', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Con về rồi', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào mừng về nhà', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Con về rồi'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ただいま', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'おかえりなさい', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'okaerinasai')),
  (@q, 'いってきます', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'itte kimasu')),
  (@q, '失礼します', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'shitsurei shimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お疲れ様です', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'otsukaresama desu')),
  (@q, 'いただきます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itadakimasu')),
  (@q, 'ごちそうさまでした', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gochisousama deshita')),
  (@q, 'お先に失礼します', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'osaki ni shitsurei shimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'ごちそうさまでした', 'romaji', 'gochisousama deshita'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cảm ơn vì bữa ăn (sau khi ăn)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Mời dùng bữa (trước khi ăn)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cảm ơn vì đã vất vả', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin phép tôi về trước', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Bạn khoẻ không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お元気ですか', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ogenki desu ka')),
  (@q, '元気です', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'genki desu')),
  (@q, 'まあまあです', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'maamaa desu')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konnichiwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'まあまあです', 'romaji', 'maamaa desu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cũng tạm ổn', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tôi khoẻ', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Bạn khoẻ không?', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 4, NULL);

-- Lesson: Thi vượt: Lời chào, tạm biệt
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (1, 'N5', 'Thi vượt: Lời chào, tạm biệt', NULL, 'JUMP_TEST', '{"expReward":80,"description":"","entryCostEnergy":15,"questionsPerSession":15}');
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'こんにちは', 'romaji', 'konnichiwa'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_ohayou.png', NULL, FALSE, 1, JSON_OBJECT('label', 'おはよう')),
  (@q, NULL, '/uploads/images/vocab_konnichiwa.png', NULL, TRUE, 2, JSON_OBJECT('label', 'こんにちは')),
  (@q, NULL, '/uploads/images/vocab_konbanwa.png', NULL, FALSE, 3, JSON_OBJECT('label', 'こんばんは')),
  (@q, NULL, '/uploads/images/vocab_sayounara.png', NULL, FALSE, 4, JSON_OBJECT('label', 'さようなら'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'さようなら', 'romaji', 'sayounara'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_sayounara.png', NULL, TRUE, 1, JSON_OBJECT('label', 'さようなら')),
  (@q, NULL, '/uploads/images/vocab_konnichiwa.png', NULL, FALSE, 2, JSON_OBJECT('label', 'こんにちは')),
  (@q, NULL, '/uploads/images/vocab_konbanwa.png', NULL, FALSE, 3, JSON_OBJECT('label', 'こんばんは')),
  (@q, NULL, '/uploads/images/vocab_ohayou.png', NULL, FALSE, 4, JSON_OBJECT('label', 'おはよう'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'またね', 'romaji', 'mata ne'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Hẹn gặp lại (thân mật)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tạm biệt (trang trọng)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào buổi tối', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Xin phép (trang trọng, khi rời đi)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '失礼します', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'shitsurei shimasu')),
  (@q, 'さようなら', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'sayounara')),
  (@q, 'ただいま', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'お疲れ様です', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'otsukaresama desu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Chào buổi sáng (lịch sự)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おはよう', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ohayou')),
  (@q, 'ございます', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'gozaimasu')),
  (@q, 'こんばんは', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'konbanwa')),
  (@q, 'ね', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'ne'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'じゃあね', 'romaji', 'jaa ne'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Tạm biệt nhé (rất thân mật)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tạm biệt (trang trọng)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Chào buổi sáng', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chào mừng về nhà', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Đi cẩn thận nhé (đáp lại itte kimasu)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'いってらっしゃい', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'itte rasshai')),
  (@q, 'いってきます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itte kimasu')),
  (@q, 'ただいま', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'おかえりなさい', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'okaerinasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'おかえりなさい', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'okaerinasai')),
  (@q, 'ただいま', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'tadaima')),
  (@q, 'いってきます', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'itte kimasu')),
  (@q, 'いってらっしゃい', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'itte rasshai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お先に失礼します', 'romaji', 'osaki ni shitsurei shimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin phép tôi về trước', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cảm ơn vì đã vất vả', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Mời dùng bữa', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Con về rồi', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SPEAKING', NULL, NULL, NULL, JSON_OBJECT('kana', 'お元気ですか。', 'romaji', 'ogenki desu ka.', 'vn', 'Bạn khoẻ không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お元気ですか。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ogenki desu ka.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Tôi khoẻ'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '元気です', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'genki desu')),
  (@q, 'お元気ですか', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ogenki desu ka')),
  (@q, 'まあまあです', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'maamaa desu')),
  (@q, 'こんにちは', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'konnichiwa'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cảm ơn vì bữa ăn'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ごちそうさま', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gochisousama')),
  (@q, 'でした', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'deshita')),
  (@q, 'いただき', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'itadaki')),
  (@q, 'ます', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'masu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'いただきます', 'romaji', 'itadakimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Mời dùng bữa (trước khi ăn)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cảm ơn vì bữa ăn (sau khi ăn)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cảm ơn vì đã vất vả', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin phép tôi về trước', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cảm ơn vì đã vất vả (chào đồng nghiệp)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お疲れ様です', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'otsukaresama desu')),
  (@q, 'いただきます', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'itadakimasu')),
  (@q, 'ごちそうさまでした', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gochisousama deshita')),
  (@q, 'お先に失礼します', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'osaki ni shitsurei shimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'さようなら。またね。', 'romaji', 'sayounara. mata ne.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Tạm biệt. Hẹn gặp lại.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Chào buổi sáng. Bạn khoẻ không?', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Con về rồi. Chào mừng về nhà.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Chúc ngủ ngon. Hẹn gặp ngày mai.', NULL, NULL, FALSE, 4, NULL);

-- =====================================================================
-- Topic 2: Gọi đồ ăn, đồ uống
-- =====================================================================
UPDATE topics SET title = 'Gọi đồ ăn, đồ uống', description = 'Học từ vựng đồ ăn, đồ uống cơ bản và cách gọi món lịch sự tại quán ăn.' WHERE id = 2;

-- Lesson: Bài 1: Từ vựng cơ bản
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Bài 1: Từ vựng cơ bản', 1, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶', 'romaji', 'ocha'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_ocha.png', NULL, TRUE, 1, JSON_OBJECT('label', 'お茶')),
  (@q, NULL, '/uploads/images/vocab_gohan.png', NULL, FALSE, 2, JSON_OBJECT('label', 'ご飯')),
  (@q, NULL, '/uploads/images/vocab_mizu.png', NULL, FALSE, 3, JSON_OBJECT('label', '水')),
  (@q, NULL, '/uploads/images/vocab_pan.png', NULL, FALSE, 4, JSON_OBJECT('label', 'パン'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'ご飯', 'romaji', 'gohan'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_mizu.png', NULL, FALSE, 1, JSON_OBJECT('label', '水')),
  (@q, NULL, '/uploads/images/vocab_gohan.png', NULL, TRUE, 2, JSON_OBJECT('label', 'ご飯')),
  (@q, NULL, '/uploads/images/vocab_ocha.png', NULL, FALSE, 3, JSON_OBJECT('label', 'お茶')),
  (@q, NULL, '/uploads/images/vocab_koohii.png', NULL, FALSE, 4, JSON_OBJECT('label', 'コーヒー'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', '水', 'romaji', 'mizu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_ocha.png', NULL, FALSE, 1, JSON_OBJECT('label', 'お茶')),
  (@q, NULL, '/uploads/images/vocab_pan.png', NULL, FALSE, 2, JSON_OBJECT('label', 'パン')),
  (@q, NULL, '/uploads/images/vocab_mizu.png', NULL, TRUE, 3, JSON_OBJECT('label', '水')),
  (@q, NULL, '/uploads/images/vocab_gohan.png', NULL, FALSE, 4, JSON_OBJECT('label', 'ご飯'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'パン', 'romaji', 'pan'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_koohii.png', NULL, FALSE, 1, JSON_OBJECT('label', 'コーヒー')),
  (@q, NULL, '/uploads/images/vocab_mizu.png', NULL, FALSE, 2, JSON_OBJECT('label', '水')),
  (@q, NULL, '/uploads/images/vocab_pan.png', NULL, TRUE, 3, JSON_OBJECT('label', 'パン')),
  (@q, NULL, '/uploads/images/vocab_ocha.png', NULL, FALSE, 4, JSON_OBJECT('label', 'お茶'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶', 'romaji', 'ocha'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Trà', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Nước', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cà phê', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cơm', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'コーヒー', 'romaji', 'koohii'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cà phê', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Trà', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Nước', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Bánh mì', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cơm'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ご飯', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gohan')),
  (@q, 'お茶', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'パン', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'pan')),
  (@q, '水', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Nước'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '水', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'mizu')),
  (@q, 'お茶', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'コーヒー', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'koohii')),
  (@q, 'ご飯', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'gohan'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'パン', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'pan')),
  (@q, 'お茶', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'ご飯', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gohan')),
  (@q, '水', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Trà và cơm'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お茶', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'と', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'to')),
  (@q, 'ご飯', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'gohan')),
  (@q, '水', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu')),
  (@q, 'パン', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'pan'));

-- Lesson: Bài 2: Gọi món cơ bản
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Bài 2: Gọi món cơ bản', 2, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶をください', 'romaji', 'ocha o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi (xin) trà.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi cơm.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi nước.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi cà phê.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi xin cơm.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ご飯をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gohan o kudasai')),
  (@q, 'お茶をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ocha o kudasai')),
  (@q, '水をください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'mizu o kudasai')),
  (@q, 'パンをください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'pan o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi nước'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '水', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'mizu')),
  (@q, 'を', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'o')),
  (@q, 'ください', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'kudasai')),
  (@q, 'お茶', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'ご飯', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'gohan'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '寿司', 'romaji', 'sushi'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Sushi', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Ramen', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Thịt', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cá', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Nước ép/nước ngọt'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ジュース', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'juusu')),
  (@q, 'お茶', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'コーヒー', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'koohii')),
  (@q, '水', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '肉', 'romaji', 'niku'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Thịt', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cá', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Trứng', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Rau', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cá'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '魚', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sakana')),
  (@q, '肉', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'niku')),
  (@q, '卵', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tamago')),
  (@q, '寿司', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sushi'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '寿司をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sushi o kudasai')),
  (@q, 'ジュースをください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'juusu o kudasai')),
  (@q, '肉をください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'niku o kudasai')),
  (@q, '魚をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sakana o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi nước ép'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ジュース', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'juusu')),
  (@q, 'を', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'o')),
  (@q, 'ください', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'kudasai')),
  (@q, '寿司', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sushi')),
  (@q, '肉', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'niku'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi xin cá.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '魚をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sakana o kudasai')),
  (@q, '肉をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'niku o kudasai')),
  (@q, '寿司をください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'sushi o kudasai')),
  (@q, 'ジュースをください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'juusu o kudasai'));

-- Lesson: Bài 3: Mở rộng thực đơn
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Bài 3: Mở rộng thực đơn', 3, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お願いします', 'romaji', 'onegaishimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Làm ơn / xin nhờ (lịch sự hơn kudasai)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi (thân mật)', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Bao nhiêu tiền?', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin lỗi', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi ramen (lịch sự).'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ラーメンをお願いします', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'raamen o onegaishimasu')),
  (@q, 'ラーメンをください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'raamen o kudasai')),
  (@q, '水をお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'mizu o onegaishimasu')),
  (@q, '卵をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'tamago o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi ramen (lịch sự)'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ラーメン', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'raamen')),
  (@q, 'を', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'o')),
  (@q, 'お願いします', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'onegaishimasu')),
  (@q, '卵', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'tamago')),
  (@q, '野菜', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'yasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '卵', 'romaji', 'tamago'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Trứng', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Rau', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cá', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Ramen', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Rau'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '野菜', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'yasai')),
  (@q, '卵', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'tamago')),
  (@q, '肉', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'niku')),
  (@q, 'ラーメン', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'raamen'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'メニュー', 'romaji', 'menyuu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Thực đơn', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Hoá đơn', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Đơn đặt hàng', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Nhà hàng', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'メニューをお願いします', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'menyuu o onegaishimasu')),
  (@q, '水をお願いします', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'mizu o onegaishimasu')),
  (@q, '卵をお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tamago o onegaishimasu')),
  (@q, '野菜をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'yasai o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi xem thực đơn.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'メニューをお願いします', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'menyuu o onegaishimasu')),
  (@q, 'メニューをください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'menyuu o kudasai')),
  (@q, 'ラーメンをお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'raamen o onegaishimasu')),
  (@q, '野菜をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'yasai o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Trứng và rau'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '卵', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'tamago')),
  (@q, 'と', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'to')),
  (@q, '野菜', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'yasai')),
  (@q, '肉', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'niku')),
  (@q, '魚', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'sakana'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '卵と野菜をください', 'romaji', 'tamago to yasai o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi trứng và rau.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi thịt và cá.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi trà và bánh mì.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi xem thực đơn.', NULL, NULL, FALSE, 4, NULL);

-- Lesson: Bài 4: Hỏi giá & đặt món hoàn chỉnh
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Bài 4: Hỏi giá & đặt món hoàn chỉnh', 4, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'すみません', 'romaji', 'sumimasen'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin lỗi / Này ơi (để gọi phục vụ)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cảm ơn', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Xin nhờ', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Bao nhiêu tiền?', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Xin lỗi, cho tôi xin thực đơn.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'すみません、メニューをください。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sumimasen, menyuu o kudasai.')),
  (@q, 'すみません、お会計をお願いします。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'sumimasen, okaikei o onegaishimasu.')),
  (@q, 'メニューをお願いします。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'menyuu o onegaishimasu.')),
  (@q, 'これはいくらですか。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'kore wa ikura desu ka.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'これはいくらですか', 'romaji', 'kore wa ikura desu ka'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cái này bao nhiêu tiền?', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi xem thực đơn.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Tôi muốn đặt món.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi tính tiền.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cái này bao nhiêu tiền?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'これはいくらですか', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'kore wa ikura desu ka')),
  (@q, 'メニューをください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'menyuu o kudasai')),
  (@q, 'お会計をお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'okaikei o onegaishimasu')),
  (@q, '注文をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'chuumon o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cái này bao nhiêu tiền?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'これ', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'kore')),
  (@q, 'は', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'wa')),
  (@q, 'いくら', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'ikura')),
  (@q, 'ですか', NULL, NULL, TRUE, 4, JSON_OBJECT('romaji', 'desu ka')),
  (@q, 'を', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'o'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '注文', 'romaji', 'chuumon'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Gọi món / đặt hàng', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Tính tiền', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Thực đơn', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin lỗi', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Tôi muốn đặt món.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '注文をお願いします', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'chuumon o onegaishimasu')),
  (@q, 'お会計をお願いします', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'okaikei o onegaishimasu')),
  (@q, 'メニューをお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'menyuu o onegaishimasu')),
  (@q, '水をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お会計をお願いします', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'okaikei o onegaishimasu')),
  (@q, '注文をお願いします', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'chuumon o onegaishimasu')),
  (@q, '水をお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'mizu o onegaishimasu')),
  (@q, 'メニューをお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'menyuu o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お会計をお願いします', 'romaji', 'okaikei o onegaishimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi tính tiền.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi đặt món.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi xem thực đơn.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cái này bao nhiêu tiền?', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Xin lỗi, cho tôi tính tiền.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'すみません、お会計をお願いします。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sumimasen, okaikei o onegaishimasu.')),
  (@q, 'すみません、メニューをください。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'sumimasen, menyuu o kudasai.')),
  (@q, 'お会計をください。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'okaikei o kudasai.')),
  (@q, 'これはいくらですか。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'kore wa ikura desu ka.'));

-- Lesson: Bài 5: Gọi nhiều món cùng lúc
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Bài 5: Gọi nhiều món cùng lúc', 5, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶と寿司をください', 'romaji', 'ocha to sushi o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi trà và sushi.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi cơm và cá.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi cà phê và bánh mì.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi trứng và rau.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi cơm và cá.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ご飯と魚をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gohan to sakana o kudasai')),
  (@q, 'お茶と寿司をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ocha to sushi o kudasai')),
  (@q, '肉と卵をください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'niku to tamago o kudasai')),
  (@q, 'パンとコーヒーをください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'pan to koohii o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi cà phê và bánh mì'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'コーヒー', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'koohii')),
  (@q, 'と', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'to')),
  (@q, 'パン', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'pan')),
  (@q, 'を', NULL, NULL, TRUE, 4, JSON_OBJECT('romaji', 'o')),
  (@q, 'ください', NULL, NULL, TRUE, 5, JSON_OBJECT('romaji', 'kudasai')),
  (@q, '水', NULL, NULL, FALSE, 6, JSON_OBJECT('romaji', 'mizu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'ラーメンと野菜をお願いします', 'romaji', 'raamen to yasai o onegaishimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi ramen và rau.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi trứng và nước.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi thịt và cơm.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi trà và cà phê.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi trứng và nước.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '卵と水をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'tamago to mizu o kudasai')),
  (@q, '肉と魚をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'niku to sakana o kudasai')),
  (@q, 'ラーメンと野菜をお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'raamen to yasai o onegaishimasu')),
  (@q, 'お茶とご飯をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'ocha to gohan o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '肉とご飯をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'niku to gohan o kudasai')),
  (@q, '魚とパンをください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'sakana to pan o kudasai')),
  (@q, 'お茶とコーヒーをください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ocha to koohii o kudasai')),
  (@q, '卵と野菜をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'tamago to yasai o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'すみません、メニューをお願いします', 'romaji', 'sumimasen, menyuu o onegaishimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin lỗi, cho tôi xem thực đơn.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Xin lỗi, cho tôi tính tiền.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Xin lỗi, cho tôi đặt món.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin lỗi, cái này bao nhiêu tiền?', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Sushi bao nhiêu tiền?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '寿司はいくらですか', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sushi wa ikura desu ka')),
  (@q, 'ラーメンはいくらですか', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'raamen wa ikura desu ka')),
  (@q, 'これはいくらですか', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'kore wa ikura desu ka')),
  (@q, 'メニューはいくらですか', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'menyuu wa ikura desu ka'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Sushi bao nhiêu tiền?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '寿司', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sushi')),
  (@q, 'は', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'wa')),
  (@q, 'いくら', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'ikura')),
  (@q, 'ですか', NULL, NULL, TRUE, 4, JSON_OBJECT('romaji', 'desu ka')),
  (@q, 'を', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'o'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶とご飯とパンをください', 'romaji', 'ocha to gohan to pan o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi trà, cơm và bánh mì.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi cà phê, thịt và cá.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi trứng, rau và ramen.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi nước và sushi.', NULL, NULL, FALSE, 4, NULL);

-- Lesson: Bài 6: Ôn tập - hội thoại gọi món hoàn chỉnh
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Bài 6: Ôn tập - hội thoại gọi món hoàn chỉnh', 6, 'NORMAL', NULL);
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'すみません、水をください。', 'romaji', 'sumimasen, mizu o kudasai.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin lỗi, cho tôi xin nước.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Xin lỗi, cho tôi tính tiền.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Xin lỗi, cho tôi xem thực đơn.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin lỗi, cái này bao nhiêu tiền?', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SPEAKING', NULL, NULL, NULL, JSON_OBJECT('kana', 'ラーメンをお願いします。', 'romaji', 'raamen o onegaishimasu.', 'vn', 'Cho tôi ramen.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ラーメンをお願いします。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'raamen o onegaishimasu.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi xem thực đơn được không?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'メニューをお願いします。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'menyuu o onegaishimasu.')),
  (@q, 'メニューはいくらですか。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'menyuu wa ikura desu ka.')),
  (@q, 'お会計をお願いします。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'okaikei o onegaishimasu.')),
  (@q, '注文をお願いします。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'chuumon o onegaishimasu.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'これはいくらですか', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'kore wa ikura desu ka')),
  (@q, 'お会計をお願いします', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'okaikei o onegaishimasu')),
  (@q, '注文をお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'chuumon o onegaishimasu')),
  (@q, 'すみません', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sumimasen'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '卵と魚をください', 'romaji', 'tamago to sakana o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi trứng và cá.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi thịt và rau.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi trà và bánh mì.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi cơm và nước.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi tính tiền'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お会計', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'okaikei')),
  (@q, 'を', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'o')),
  (@q, 'お願いします', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'onegaishimasu')),
  (@q, 'ください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi trà và bánh mì.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お茶とパンをください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ocha to pan o kudasai')),
  (@q, '水とご飯をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'mizu to gohan o kudasai')),
  (@q, 'コーヒーと寿司をください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'koohii to sushi o kudasai')),
  (@q, '肉と卵をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'niku to tamago o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'すみません、お会計をお願いします。', 'romaji', 'sumimasen, okaikei o onegaishimasu.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin lỗi, cho tôi tính tiền.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Xin lỗi, cho tôi xem thực đơn.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Xin lỗi, cho tôi xin nước.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Xin lỗi, tôi muốn đặt món.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SPEAKING', NULL, NULL, NULL, JSON_OBJECT('kana', 'これはいくらですか。', 'romaji', 'kore wa ikura desu ka.', 'vn', 'Cái này bao nhiêu tiền?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'これはいくらですか。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'kore wa ikura desu ka.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi gọi món: cơm, cá và rau.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ご飯と魚と野菜を注文します', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'gohan to sakana to yasai o chuumon shimasu')),
  (@q, 'ご飯と魚と野菜をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'gohan to sakana to yasai o kudasai')),
  (@q, 'ご飯と魚と野菜はいくらですか', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'gohan to sakana to yasai wa ikura desu ka')),
  (@q, 'ご飯と魚と野菜をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'gohan to sakana to yasai o onegaishimasu'));

-- Lesson: Ôn tập tốc độ: Gọi đồ ăn, đồ uống
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Ôn tập tốc độ: Gọi đồ ăn, đồ uống', NULL, 'TIMED_REVIEW', '{"expReward":30,"description":"","replayExpRatio":0.3,"starThresholds":[90,150],"entryCostEnergy":5,"questionsPerSession":12}');
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶', 'romaji', 'ocha'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Trà', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Nước', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cà phê', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cơm', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Nước'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '水', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'mizu')),
  (@q, 'お茶', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'コーヒー', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'koohii')),
  (@q, 'ジュース', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'juusu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'パン', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'pan')),
  (@q, 'ご飯', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'gohan')),
  (@q, 'お茶', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'コーヒー', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'koohii'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '水をください', 'romaji', 'mizu o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi xin nước.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi xin trà.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi xin cơm.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi tính tiền.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Trà và cơm'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お茶', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ocha')),
  (@q, 'と', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'to')),
  (@q, 'ご飯', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'gohan')),
  (@q, '水', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi cá.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '魚をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sakana o kudasai')),
  (@q, '肉をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'niku o kudasai')),
  (@q, '卵をください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'tamago o kudasai')),
  (@q, '寿司をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sushi o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'メニュー', 'romaji', 'menyuu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Thực đơn', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Hoá đơn', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Đơn đặt hàng', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Nhà hàng', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi ramen (lịch sự).'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ラーメンをお願いします', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'raamen o onegaishimasu')),
  (@q, 'ラーメンをください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'raamen o kudasai')),
  (@q, '野菜をお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'yasai o onegaishimasu')),
  (@q, '卵をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'tamago o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '卵と野菜をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'tamago to yasai o kudasai')),
  (@q, '肉と魚をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'niku to sakana o kudasai')),
  (@q, 'お茶とパンをください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'ocha to pan o kudasai')),
  (@q, '水とご飯をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu to gohan o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'これはいくらですか', 'romaji', 'kore wa ikura desu ka'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cái này bao nhiêu tiền?', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi tính tiền.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi xem thực đơn.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Tôi muốn đặt món.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi tính tiền.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お会計をお願いします', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'okaikei o onegaishimasu')),
  (@q, '注文をお願いします', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'chuumon o onegaishimasu')),
  (@q, 'メニューをお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'menyuu o onegaishimasu')),
  (@q, '水をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'すみません', 'romaji', 'sumimasen'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Xin lỗi / này ơi (gọi phục vụ)', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cảm ơn', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Xin nhờ', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Bao nhiêu tiền?', NULL, NULL, FALSE, 4, NULL);

-- Lesson: Thi vượt: Gọi đồ ăn, đồ uống
INSERT INTO lessons (topic_id, jlpt_level, title, order_index, lesson_type, config_json) VALUES (2, 'N5', 'Thi vượt: Gọi đồ ăn, đồ uống', NULL, 'JUMP_TEST', '{"expReward":80,"description":"","entryCostEnergy":15,"questionsPerSession":15}');
SET @lesson_id = LAST_INSERT_ID();
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶', 'romaji', 'ocha'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_gohan.png', NULL, FALSE, 1, JSON_OBJECT('label', 'ご飯')),
  (@q, NULL, '/uploads/images/vocab_ocha.png', NULL, TRUE, 2, JSON_OBJECT('label', 'お茶')),
  (@q, NULL, '/uploads/images/vocab_mizu.png', NULL, FALSE, 3, JSON_OBJECT('label', '水')),
  (@q, NULL, '/uploads/images/vocab_koohii.png', NULL, FALSE, 4, JSON_OBJECT('label', 'コーヒー'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SELECT_IMAGE', NULL, NULL, NULL, JSON_OBJECT('kana', '水', 'romaji', 'mizu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, NULL, '/uploads/images/vocab_mizu.png', NULL, TRUE, 1, JSON_OBJECT('label', '水')),
  (@q, NULL, '/uploads/images/vocab_pan.png', NULL, FALSE, 2, JSON_OBJECT('label', 'パン')),
  (@q, NULL, '/uploads/images/vocab_ocha.png', NULL, FALSE, 3, JSON_OBJECT('label', 'お茶')),
  (@q, NULL, '/uploads/images/vocab_gohan.png', NULL, FALSE, 4, JSON_OBJECT('label', 'ご飯'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '寿司', 'romaji', 'sushi'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Sushi', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Ramen', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Thịt', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Trứng', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi xin trà.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お茶をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ocha o kudasai')),
  (@q, '水をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'mizu o kudasai')),
  (@q, 'コーヒーをください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'koohii o kudasai')),
  (@q, 'ご飯をください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'gohan o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi nước ép'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ジュース', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'juusu')),
  (@q, 'を', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'o')),
  (@q, 'ください', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'kudasai')),
  (@q, 'お茶', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'ocha'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '野菜', 'romaji', 'yasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Rau', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Trứng', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Thịt', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cá', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Trứng'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, '卵', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'tamago')),
  (@q, '野菜', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'yasai')),
  (@q, '肉', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'niku')),
  (@q, '魚', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'sakana'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_SELECT', NULL, NULL, NULL, NULL);
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'これはいくらですか', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'kore wa ikura desu ka')),
  (@q, 'お会計をお願いします', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'okaikei o onegaishimasu')),
  (@q, 'メニューをお願いします', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'menyuu o onegaishimasu')),
  (@q, '注文をお願いします', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'chuumon o onegaishimasu'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', '注文をお願いします', 'romaji', 'chuumon o onegaishimasu'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Tôi muốn đặt món.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi tính tiền.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi xem thực đơn.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cái này bao nhiêu tiền?', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'SPEAKING', NULL, NULL, NULL, JSON_OBJECT('kana', 'ラーメンをお願いします。', 'romaji', 'raamen o onegaishimasu.', 'vn', 'Cho tôi ramen.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'ラーメンをお願いします。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'raamen o onegaishimasu.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cho tôi trà và sushi.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'お茶と寿司をください', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'ocha to sushi o kudasai')),
  (@q, 'ご飯と魚をください', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'gohan to sakana o kudasai')),
  (@q, '肉と卵をください', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'niku to tamago o kudasai')),
  (@q, '水とパンをください', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'mizu to pan o kudasai'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'LISTEN_AND_ARRANGE', NULL, NULL, NULL, JSON_OBJECT('vn', 'Cái này bao nhiêu tiền?'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'これ', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'kore')),
  (@q, 'は', NULL, NULL, TRUE, 2, JSON_OBJECT('romaji', 'wa')),
  (@q, 'いくら', NULL, NULL, TRUE, 3, JSON_OBJECT('romaji', 'ikura')),
  (@q, 'ですか', NULL, NULL, TRUE, 4, JSON_OBJECT('romaji', 'desu ka')),
  (@q, 'を', NULL, NULL, FALSE, 5, JSON_OBJECT('romaji', 'o'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'ご飯と魚をください', 'romaji', 'gohan to sakana o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi cơm và cá.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi trà và bánh mì.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi thịt và trứng.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi rau và ramen.', NULL, NULL, FALSE, 4, NULL);
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_JP', NULL, NULL, NULL, JSON_OBJECT('vn', 'Xin lỗi, cho tôi tính tiền.'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'すみません、お会計をお願いします。', NULL, NULL, TRUE, 1, JSON_OBJECT('romaji', 'sumimasen, okaikei o onegaishimasu.')),
  (@q, 'すみません、メニューをください。', NULL, NULL, FALSE, 2, JSON_OBJECT('romaji', 'sumimasen, menyuu o kudasai.')),
  (@q, 'お会計をください。', NULL, NULL, FALSE, 3, JSON_OBJECT('romaji', 'okaikei o kudasai.')),
  (@q, 'これはいくらですか。', NULL, NULL, FALSE, 4, JSON_OBJECT('romaji', 'kore wa ikura desu ka.'));
INSERT INTO lesson_questions (lesson_id, question_type, question_text, audio_url, image_url, metadata_json) VALUES (@lesson_id, 'TRANSLATE_TO_VN', NULL, NULL, NULL, JSON_OBJECT('kana', 'お茶とご飯とパンをください', 'romaji', 'ocha to gohan to pan o kudasai'));
SET @q = LAST_INSERT_ID();
INSERT INTO lesson_question_options (question_id, option_text, image_url, audio_url, is_correct, order_index, metadata_json) VALUES
  (@q, 'Cho tôi trà, cơm và bánh mì.', NULL, NULL, TRUE, 1, NULL),
  (@q, 'Cho tôi cà phê, thịt và cá.', NULL, NULL, FALSE, 2, NULL),
  (@q, 'Cho tôi trứng, rau và ramen.', NULL, NULL, FALSE, 3, NULL),
  (@q, 'Cho tôi nước và sushi.', NULL, NULL, FALSE, 4, NULL);
