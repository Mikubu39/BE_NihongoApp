-- Chuẩn hoá bản dịch こんにちは ("Chào buổi trưa") đồng bộ với "Chào buổi sáng" và "Chào buổi tối"
-- Loại bỏ dấu ngoặc đơn gây mất thẩm mỹ và không nhất quán.

-- 1. Cập nhật bảng vocabulary
UPDATE vocabulary
SET meaning_vn = REPLACE(meaning_vn, 'Chào (buổi trưa/chiều)', 'Chào buổi trưa')
WHERE meaning_vn LIKE '%Chào (buổi trưa/chiều)%';

UPDATE vocabulary
SET meaning_vn = REPLACE(meaning_vn, 'Chào (buổi trưa)', 'Chào buổi trưa')
WHERE meaning_vn LIKE '%Chào (buổi trưa)%';

-- 2. Cập nhật các lựa chọn đáp án trắc nghiệm
UPDATE lesson_question_options
SET option_text = REPLACE(option_text, 'Chào (buổi trưa/chiều)', 'Chào buổi trưa')
WHERE option_text LIKE '%Chào (buổi trưa/chiều)%';

UPDATE lesson_question_options
SET option_text = REPLACE(option_text, 'Chào (buổi trưa)', 'Chào buổi trưa')
WHERE option_text LIKE '%Chào (buổi trưa)%';

-- 3. Cập nhật câu hỏi và metadata đề bài
UPDATE lesson_questions
SET question_text = REPLACE(question_text, 'Chào (buổi trưa/chiều)', 'Chào buổi trưa')
WHERE question_text LIKE '%Chào (buổi trưa/chiều)%';

UPDATE lesson_questions
SET question_text = REPLACE(question_text, 'Chào (buổi trưa)', 'Chào buổi trưa')
WHERE question_text LIKE '%Chào (buổi trưa)%';

UPDATE lesson_questions
SET metadata_json = JSON_SET(metadata_json, '$.vn', 'Chào buổi trưa')
WHERE JSON_UNQUOTE(JSON_EXTRACT(metadata_json, '$.vn')) IN ('Chào (buổi trưa)', 'Chào (buổi trưa/chiều)');
