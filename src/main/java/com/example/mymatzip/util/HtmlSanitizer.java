/*
 * ============================================================================
 *  파일명    : HtmlSanitizer.java
 *  위치      : com.example.mymatzip.util (유틸리티 패키지)
 *  역할      : XSS(Cross-Site Scripting) 공격을 방어하는 "HTML 소독기"
 * ============================================================================
 *
 *  ■ XSS 공격이란?
 *    악의적인 사용자가 입력란에 JavaScript 코드를 넣어서,
 *    다른 사용자의 브라우저에서 실행되게 하는 공격입니다.
 *
 *    예시: 리뷰 내용에 다음을 입력
 *      <script>alert('해킹!')</script>
 *    → 다른 사용자가 이 리뷰를 보면 "해킹!" 팝업이 뜸
 *    → 더 나쁜 경우: 쿠키(세션 정보)를 훔쳐서 로그인 세션을 탈취할 수 있음!
 *
 *  ■ 이 클래스의 방어 방식
 *    HTML 특수 문자를 "이스케이프(escape)"하여 무력화합니다.
 *    < → &lt;  (브라우저가 태그로 인식하지 않음)
 *    > → &gt;
 *    " → &quot;
 *    & → &amp;
 *    ' → &#39;
 *
 *    비유: 폭죽(위험한 코드)의 심지를 잘라버리는 것
 *    폭죽 모양은 그대로 보이지만(글자로 표시), 터지지(실행되지) 않음
 *
 *  ■ 사용 예시
 *    String safeContent = HtmlSanitizer.sanitize(userInput);
 *    → "<script>" → "&lt;script&gt;" 로 변환
 * ============================================================================
 */

// ── 패키지 선언 ──────────────────────────────────────────────
package com.example.mymatzip.util;

// ── import 문 ────────────────────────────────────────────────

// HtmlUtils: Spring에서 제공하는 HTML 이스케이프 유틸리티
// HTML 특수 문자를 안전한 문자로 변환해주는 기능을 제공
import org.springframework.web.util.HtmlUtils;

// ── 클래스 선언 ──────────────────────────────────────────────
// XSS 방어 유틸리티 클래스
// 모든 메서드가 static이므로 객체를 생성하지 않고 바로 사용 가능
//   사용법: HtmlSanitizer.sanitize("위험한 문자열")
public class HtmlSanitizer {

    // ── sanitize 메서드 ──────────────────────────────────────
    // 역할: 입력 문자열에서 HTML 특수 문자를 이스케이프하여 XSS 공격을 방어합니다.
    //
    // 매개변수: String input — 사용자가 입력한 원본 문자열 (위험할 수 있음)
    // 반환값: String — HTML 특수 문자가 이스케이프된 안전한 문자열
    //
    // 변환 예시:
    //   입력: <script>alert('XSS')</script>
    //   출력: &lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;
    //   → 브라우저에서 "<script>alert('XSS')</script>"로 표시되지만 실행되지 않음!
    //
    // 비유: 음식(사용자 입력)을 손님(브라우저)에게 내기 전에
    //       유해 물질(악성 스크립트)을 제거하는 "소독 과정"
    public static String sanitize(String input) {
        // null이면 그대로 null 반환 (NPE 방지)
        if (input == null) {
            return null;
        }

        // Spring의 HtmlUtils.htmlEscape()를 사용하여 HTML 특수 문자를 이스케이프
        // 이 메서드가 <, >, ", &, ' 등을 안전한 HTML 엔티티로 변환합니다.
        return HtmlUtils.htmlEscape(input);
    }
}
