-- Bai kiem tra dau vao (Placement Test): do nhi phan qua cac Topic (theo order_index)
-- de tim diem xuat phat phu hop cho user moi, tranh phai hoc lai noi dung da biet.
CREATE TABLE placement_attempts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    status ENUM('IN_PROGRESS', 'FINISHED') NOT NULL DEFAULT 'IN_PROGRESS',
    -- Vi tri (index, khong phai id) trong danh sach Topic da sap theo order_index.
    -- low = -1 nghia la chua xac nhan qua duoc topic nao. high = so luong Topic
    -- nghia la chua xac nhan rot o topic nao.
    low_index INT NOT NULL,
    high_index INT NOT NULL,
    -- Topic dang duoc do o vong hien tai. NULL khi da FINISHED.
    probe_topic_id BIGINT NULL,
    rounds_used INT NOT NULL DEFAULT 0,
    -- Topic cuoi cung duoc xac nhan qua (moi topic co order_index <= topic nay se
    -- duoc danh dau COMPLETED). NULL nghia la khong topic nao duoc tu dong hoan thanh.
    result_topic_id BIGINT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (probe_topic_id) REFERENCES topics(id) ON DELETE SET NULL,
    FOREIGN KEY (result_topic_id) REFERENCES topics(id) ON DELETE SET NULL,
    INDEX idx_placement_attempts_user (user_id)
);
