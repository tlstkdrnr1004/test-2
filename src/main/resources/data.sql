-- ============================================================
-- [data.sql] 테스트 데이터 자동 삽입 파일
-- ============================================================
-- 역할: 서버가 시작될 때 자동으로 실행되는 SQL 스크립트입니다.
--       Entity(@Entity)에서 정의한 테이블에 샘플 데이터를 INSERT합니다.
--
-- 비유: 새 가게를 열었을 때 진열대에 샘플 상품을 미리 진열해두는 것
--       → 테스트할 때 매번 수동으로 데이터를 입력하지 않아도 됩니다.
--
-- ★ 실행 순서: application.properties의 설정에 의해 결정됩니다.
--   1) spring.jpa.hibernate.ddl-auto=create → JPA가 테이블 생성 (CREATE TABLE)
--   2) spring.jpa.defer-datasource-initialization=true → data.sql 실행 대기
--   3) spring.sql.init.mode=always → data.sql의 INSERT문 자동 실행
--
-- ★ 주의: ddl-auto=create이므로 서버를 재시작할 때마다 데이터가 초기화됩니다!
-- ============================================================

-- ── 회원(Member) 데이터 ─────────────────────────────────────
-- 테스트용 계정 3개를 미리 생성합니다. (비밀번호는 모두 '1234')
-- role 컬럼: 'ADMIN' = 관리자 (다른 사람 맛집도 삭제 가능)
--            'USER'  = 일반 사용자 (본인 맛집만 수정/삭제 가능)
--
-- ★ id 컬럼은 @GeneratedValue(IDENTITY)에 의해 H2가 자동으로 1, 2, 3... 부여
-- ★ NOW() 함수: 현재 날짜와 시간을 자동으로 넣어줌
INSERT INTO member (email, password, nickname, role, created_at) VALUES
('admin@test.com', '1234', '관리자', 'ADMIN', NOW());
-- → id=1, 관리자 계정 (이메일: admin@test.com, 비번: 1234)

INSERT INTO member (email, password, nickname, role, created_at) VALUES
('user1@test.com', '1234', '맛집탐험가', 'USER', NOW());
-- → id=2, 일반 사용자 계정

INSERT INTO member (email, password, nickname, role, created_at) VALUES
('user2@test.com', '1234', '먹보킹', 'USER', NOW());
-- → id=3, 일반 사용자 계정

-- ── 맛집(Restaurant) 데이터 ─────────────────────────────────
-- 6개 카테고리(KOREAN, CHINESE, JAPANESE, WESTERN, CAFE, ETC)별 샘플 맛집
-- member_id: 이 맛집을 등록한 회원의 id (1=관리자, 2=맛집탐험가, 3=먹보킹)
-- category: Entity의 Category enum 값과 정확히 일치해야 함 (대소문자 주의!)
INSERT INTO restaurant (name, category, address, phone, description, member_id, created_at) VALUES
('김치찌개 명가', 'KOREAN', '서울시 강남구 역삼동 123-4', '02-1234-5678', '30년 전통 김치찌개 맛집. 직접 담근 김치로 끓여내는 깊은 맛!', 1, NOW());
-- → restaurant_id=1, 관리자(id=1)가 등록한 한식 맛집

INSERT INTO restaurant (name, category, address, phone, description, member_id, created_at) VALUES
('마라탕 천국', 'CHINESE', '서울시 마포구 합정동 55-1', '02-2345-6789', '마라탕과 꿔바로우가 일품인 중식당', 2, NOW());
-- → restaurant_id=2, 맛집탐험가(id=2)가 등록한 중식 맛집

INSERT INTO restaurant (name, category, address, phone, description, member_id, created_at) VALUES
('스시 오마카세', 'JAPANESE', '서울시 송파구 잠실동 88-3', '02-3456-7890', '신선한 회와 초밥을 즐길 수 있는 오마카세 전문점', 1, NOW());
-- → restaurant_id=3, 관리자(id=1)가 등록한 일식 맛집

INSERT INTO restaurant (name, category, address, phone, description, member_id, created_at) VALUES
('파스타 공방', 'WESTERN', '서울시 서초구 반포동 22-7', '02-4567-8901', '수제 파스타와 리조또가 맛있는 이탈리안 레스토랑', 3, NOW());
-- → restaurant_id=4, 먹보킹(id=3)이 등록한 양식 맛집

INSERT INTO restaurant (name, category, address, phone, description, member_id, created_at) VALUES
('카페 드리퍼', 'CAFE', '서울시 용산구 이태원동 77-2', '02-5678-9012', '핸드드립 커피와 수제 디저트가 유명한 감성 카페', 2, NOW());
-- → restaurant_id=5, 맛집탐험가(id=2)가 등록한 카페

INSERT INTO restaurant (name, category, address, phone, description, member_id, created_at) VALUES
('백반의 정석', 'KOREAN', '서울시 종로구 광화문 11-5', '02-6789-0123', '매일 바뀌는 반찬과 든든한 백반 한 상', 3, NOW());
-- → restaurant_id=6, 먹보킹(id=3)이 등록한 한식 맛집 (KOREAN 카테고리 2번째)

-- ── 리뷰(Review) 데이터 ─────────────────────────────────────
-- 10개의 샘플 리뷰 데이터
-- member_id: 리뷰를 작성한 회원의 id
-- restaurant_id: 리뷰 대상 맛집의 id
-- rating: 별점 (1~5, 정수)
--
-- ★ 본인이 등록한 맛집에도 리뷰를 달 수 있습니다.
-- ★ 한 맛집에 여러 리뷰가 달리면 평균 별점이 계산됩니다.
INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('김치찌개가 정말 맛있어요! 밥도 무한리필이라 든든합니다.', 5, 2, 1, FALSE, NOW());
-- → 맛집탐험가(id=2)가 김치찌개 명가(id=1)에 별점 5점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('가격 대비 양이 많고 맛도 좋아요. 점심 추천!', 4, 3, 1, FALSE, NOW());
-- → 먹보킹(id=3)이 김치찌개 명가(id=1)에 별점 4점 리뷰
-- → 김치찌개 명가의 평균 별점: (5+4)/2 = 4.5

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('마라탕 국물이 진하고 재료가 신선해요.', 5, 1, 2, FALSE, NOW());
-- → 관리자(id=1)가 마라탕 천국(id=2)에 별점 5점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('꿔바로우도 바삭하고 맛있습니다.', 4, 3, 2, FALSE, NOW());
-- → 먹보킹(id=3)이 마라탕 천국(id=2)에 별점 4점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('초밥 퀄리티가 높아요. 런치 세트 추천합니다.', 5, 2, 3, FALSE, NOW());
-- → 맛집탐험가(id=2)가 스시 오마카세(id=3)에 별점 5점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('가격이 좀 있지만 분위기와 맛 모두 만족!', 4, 3, 3, FALSE, NOW());
-- → 먹보킹(id=3)이 스시 오마카세(id=3)에 별점 4점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('까르보나라가 크림 농도가 딱 좋아요.', 5, 1, 4, FALSE, NOW());
-- → 관리자(id=1)가 파스타 공방(id=4)에 별점 5점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('분위기 좋고 데이트 코스로 추천합니다.', 4, 2, 4, FALSE, NOW());
-- → 맛집탐험가(id=2)가 파스타 공방(id=4)에 별점 4점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('핸드드립 커피가 정말 향이 좋아요. 디저트도 맛있어요.', 5, 1, 5, FALSE, NOW());
-- → 관리자(id=1)가 카페 드리퍼(id=5)에 별점 5점 리뷰

INSERT INTO review (content, rating, member_id, restaurant_id, reported, created_at) VALUES
('백반집인데 반찬이 매일 바뀌어서 안 질려요!', 4, 2, 6, FALSE, NOW());
-- → 맛집탐험가(id=2)가 백반의 정석(id=6)에 별점 4점 리뷰
