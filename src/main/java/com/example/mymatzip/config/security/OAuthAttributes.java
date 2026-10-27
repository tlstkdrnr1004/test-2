// ============================================================
// [OAuthAttributes.java] OAuth2 소셜 로그인 속성 파싱 클래스
// ============================================================
// 역할: Google, Kakao, Naver 등 소셜 로그인 제공자(Provider)마다
//       사용자 정보를 다른 형식(JSON 구조)으로 제공하는데,
//       이 클래스가 각 제공자의 형식을 "통일된 양식"으로 변환해줍니다.
//
// 비유: 여러 나라(Google, Kakao, Naver)의 여권 양식이 각각 다르지만,
//       출입국 심사대에서는 "이름, 이메일" 같은 공통 정보만 확인하면 됩니다.
//       이 클래스가 각 나라의 여권에서 공통 정보를 뽑아내는 "번역기" 역할을 합니다.
//
// 각 소셜 로그인 제공자의 사용자 정보 JSON 구조:
//   ■ Google: { "sub": "123", "name": "홍길동", "email": "hong@gmail.com" }
//   ■ Kakao:  { "id": 123, "kakao_account": { "email": "...", "profile": { "nickname": "..." } } }
//   ■ Naver:  { "response": { "id": "abc", "name": "홍길동", "email": "..." } }
//
// 사용처: CustomOAuth2UserService에서 소셜 로그인 사용자 정보를 파싱할 때
// ============================================================

// ── 패키지 선언 ──────────────────────────────────────────────
package com.example.mymatzip.config.security;

// ── import 문 ────────────────────────────────────────────────

// @Getter: 모든 필드의 getter 메서드를 Lombok이 자동 생성
import lombok.Getter;

// Map: 키-값 쌍으로 데이터를 저장하는 자료구조
// 소셜 로그인 응답 데이터(JSON)가 Map<String, Object> 형태로 전달됩니다.
import java.util.Map;

// ── 클래스 선언 ──────────────────────────────────────────────

// @Getter: getName(), getEmail() 등의 getter 메서드를 자동 생성
@Getter
public class OAuthAttributes {

    // ── 필드 ─────────────────────────────────────────────────

    // attributes: 소셜 로그인 제공자가 전달한 원본 사용자 정보 (JSON → Map)
    // 비유: 각 나라의 여권 원본 데이터
    private Map<String, Object> attributes;

    // nameAttributeKey: 사용자를 식별하는 키 이름
    // Google: "sub", Kakao: "id", Naver: "response"
    private String nameAttributeKey;

    // name: 사용자 이름 (닉네임으로 사용)
    private String name;

    // email: 사용자 이메일
    private String email;

    // ── 생성자 (private) ──────────────────────────────────────
    // 외부에서 직접 new로 생성하지 못하게 하고,
    // 아래의 정적 팩토리 메서드(of, ofGoogle, ofKakao, ofNaver)를 통해서만 생성
    private OAuthAttributes(Map<String, Object> attributes,
                            String nameAttributeKey,
                            String name,
                            String email) {
        this.attributes = attributes;
        this.nameAttributeKey = nameAttributeKey;
        this.name = name;
        this.email = email;
    }

    // ── 정적 팩토리 메서드: 소셜 로그인 제공자별 분기 ───────────
    // registrationId: 어떤 소셜 로그인인지 구분 ("google", "kakao", "naver")
    // userNameAttributeName: 사용자 식별 키 이름
    // attributes: 소셜 로그인 응답 데이터 (Map 형태)
    //
    // 비유: 여권(attributes)을 받아서 어느 나라(registrationId) 것인지 확인 후
    //       해당 나라의 양식에 맞게 정보를 추출하는 것
    public static OAuthAttributes of(String registrationId,
                                     String userNameAttributeName,
                                     Map<String, Object> attributes) {

        // "kakao"인 경우 → 카카오 전용 파싱 메서드 호출
        if ("kakao".equals(registrationId)) {
            return ofKakao(userNameAttributeName, attributes);
        }

        // "naver"인 경우 → 네이버 전용 파싱 메서드 호출
        if ("naver".equals(registrationId)) {
            return ofNaver(userNameAttributeName, attributes);
        }

        // 그 외 (기본값 = Google) → 구글 전용 파싱 메서드 호출
        return ofGoogle(userNameAttributeName, attributes);
    }

    // ── Google 사용자 정보 파싱 ──────────────────────────────────
    // Google 응답 형식: { "sub": "123", "name": "홍길동", "email": "hong@gmail.com" }
    // sub = 구글 고유 사용자 ID
    // name = 사용자 이름
    // email = 사용자 이메일
    private static OAuthAttributes ofGoogle(String userNameAttributeName,
                                            Map<String, Object> attributes) {
        return new OAuthAttributes(
                attributes,
                userNameAttributeName,
                (String) attributes.get("name"),    // Google은 "name" 키에 이름이 있음
                (String) attributes.get("email")    // Google은 "email" 키에 이메일이 있음
        );
    }

    // ── Kakao 사용자 정보 파싱 ──────────────────────────────────
    // Kakao 응답 형식 (중첩 구조):
    //   {
    //     "id": 12345,
    //     "kakao_account": {
    //       "email": "hong@kakao.com",
    //       "profile": {
    //         "nickname": "홍길동"
    //       }
    //     }
    //   }
    // 비유: 봉투(attributes) 안에 작은 봉투(kakao_account)가 있고,
    //       그 안에 또 작은 봉투(profile)가 있는 구조
    @SuppressWarnings("unchecked")
    private static OAuthAttributes ofKakao(String userNameAttributeName,
                                           Map<String, Object> attributes) {
        // kakao_account 안의 데이터를 꺼냄
        Map<String, Object> kakaoAccount = (Map<String, Object>) attributes.get("kakao_account");

        // kakao_account → profile 안의 데이터를 꺼냄
        Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");

        return new OAuthAttributes(
                attributes,
                userNameAttributeName,
                (String) profile.get("nickname"),       // profile.nickname에서 이름 추출
                (String) kakaoAccount.get("email")      // kakao_account.email에서 이메일 추출
        );
    }

    // ── Naver 사용자 정보 파싱 ──────────────────────────────────
    // Naver 응답 형식:
    //   {
    //     "resultcode": "00",
    //     "message": "success",
    //     "response": {
    //       "id": "abc123",
    //       "name": "홍길동",
    //       "email": "hong@naver.com"
    //     }
    //   }
    // 비유: 편지 봉투(attributes) 안에 실제 내용(response)이 들어있는 구조
    @SuppressWarnings("unchecked")
    private static OAuthAttributes ofNaver(String userNameAttributeName,
                                           Map<String, Object> attributes) {
        // "response" 안의 실제 사용자 데이터를 꺼냄
        Map<String, Object> response = (Map<String, Object>) attributes.get("response");

        return new OAuthAttributes(
                attributes,
                userNameAttributeName,
                (String) response.get("name"),     // response.name에서 이름 추출
                (String) response.get("email")     // response.email에서 이메일 추출
        );
    }
}
