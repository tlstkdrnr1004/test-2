/*
 * ============================================================================
 *  파일명    : LoginInterceptor.java
 *  위치      : com.example.mymatzip.config (설정 패키지)
 *  역할      : 로그인하지 않은 사용자가 보호된 페이지에 접근하는 것을 차단하는 "경비원"
 * ============================================================================
 *
 *  ■ 비유
 *    놀이공원 입구의 티켓 검사원과 같습니다.
 *    - 티켓(세션에 저장된 로그인 정보)이 있으면 → 놀이기구(페이지) 이용 가능
 *    - 티켓이 없으면 → 매표소(로그인 페이지)로 안내
 *
 *  ■ MVC에서의 위치
 *    Controller 앞단에서 동작하는 "필터/경비원" 역할입니다.
 *    요청(Request)이 Controller에 도달하기 전에 먼저 이 인터셉터가 검사합니다.
 *
 *    [브라우저] → [인터셉터(여기)] → [Controller] → [Service] → [DB]
 *                 ↓ (로그인 안 됨)
 *              [로그인 페이지로 리다이렉트]
 *
 *  ■ 동작 흐름
 *    1) 사용자가 어떤 URL로 요청을 보냄
 *    2) WebMvcConfig에서 제외한 경로(로그인, 회원가입 등)가 아니면 이 인터셉터 실행
 *    3) 세션에서 "loginMember" 정보를 확인
 *    4) 있으면 → true 반환 (요청을 Controller로 전달)
 *    5) 없으면 → 로그인 페이지로 리다이렉트, false 반환 (요청 중단)
 *
 *  ■ URL 매핑
 *    이 파일 자체는 URL을 처리하지 않습니다.
 *    WebMvcConfig.java에서 어떤 URL에 적용할지 설정합니다.
 * ============================================================================
 */

// ── 패키지 선언 ──────────────────────────────────────────────
// 이 파일이 config(설정) 패키지에 속함을 선언합니다.
package com.example.mymatzip.config;

// ── import 문 (외부 라이브러리 가져오기) ─────────────────────

// HttpServletRequest: 클라이언트(브라우저)가 보낸 요청 정보를 담는 객체
// (어떤 URL로 왔는지, 어떤 데이터를 보냈는지 등의 정보를 가지고 있음)
import jakarta.servlet.http.HttpServletRequest;

// HttpServletResponse: 서버가 클라이언트(브라우저)에게 보낼 응답 정보를 담는 객체
// (리다이렉트, 상태코드 설정, 응답 데이터 전송 등에 사용)
import jakarta.servlet.http.HttpServletResponse;

// HttpSession: 서버가 사용자별로 관리하는 저장 공간
// 비유: 놀이공원에서 손목에 차는 팔찌 같은 것. 누가 왔는지 식별하는 용도.
// 로그인하면 세션에 회원 정보를 저장하고, 이후 요청마다 확인합니다.
import jakarta.servlet.http.HttpSession;

// @Component: 이 클래스를 스프링이 자동으로 관리(생성, 보관)하도록 등록하는 어노테이션
// 스프링 컨테이너라는 "창고"에 이 객체를 보관해두고 필요할 때 꺼내 씁니다.
import org.springframework.stereotype.Component;

// HandlerInterceptor: 스프링이 제공하는 인터셉터 인터페이스
// 이 인터페이스를 구현(implements)하면 요청을 가로채는 기능을 만들 수 있습니다.
// 인터페이스 = "이런 메서드를 반드시 만들어야 한다"는 약속(계약서)
import org.springframework.web.servlet.HandlerInterceptor;

// ── @Component 어노테이션 ───────────────────────────────────
// 이 클래스를 스프링의 "빈(Bean)"으로 등록합니다.
// 빈 = 스프링이 대신 만들어서 관리해주는 객체
// 이렇게 등록해두면 WebMvcConfig에서 자동으로 주입(DI)받아 사용할 수 있습니다.
@Component
// ── 클래스 선언 ─────────────────────────────────────────────
// public: 다른 패키지에서도 접근 가능
// class LoginInterceptor: "로그인 인터셉터"라는 이름의 클래스
// implements HandlerInterceptor: HandlerInterceptor 인터페이스를 구현(약속 이행)
//   → preHandle, postHandle, afterCompletion 메서드를 사용할 수 있음
//   → 여기서는 preHandle만 사용 (요청이 Controller에 도달하기 "전"에 실행)
public class LoginInterceptor implements HandlerInterceptor {

    // ── preHandle 메서드 ────────────────────────────────────
    // ■ 역할: 요청이 Controller에 도달하기 "전"에 실행되는 메서드
    // ■ 실행 시점: 모든 HTTP 요청이 들어올 때 (WebMvcConfig에서 제외한 경로 제외)
    // ■ 매개변수:
    //   - request  : 클라이언트가 보낸 요청 정보 (URL, 파라미터, 헤더 등)
    //   - response : 서버가 보낼 응답 정보 (리다이렉트 등에 사용)
    //   - handler  : 이 요청을 처리할 Controller 메서드 정보 (여기서는 사용 안 함)
    // ■ 반환값:
    //   - true  → 요청을 Controller로 전달 (= "통과시켜!")
    //   - false → 요청을 여기서 중단 (= "입장 불가!")
    // ■ throws Exception: 이 메서드 실행 중 예외(에러)가 발생할 수 있음을 선언
    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        // ── 1단계: 세션 가져오기 ────────────────────────────
        // request.getSession(false)의 의미:
        //   - false: 세션이 없으면 새로 만들지 말고 null을 반환해라
        //   - true (또는 생략): 세션이 없으면 새로 만들어라
        // 여기서는 "이미 로그인한 사람"을 확인하는 것이므로,
        // 세션이 없다면 새로 만들 필요가 없습니다.
        // 비유: "티켓이 있나요?" 라고 물어보는 것. 없다고 새로 발급하지 않음.
        HttpSession session = request.getSession(false);

        // ── 2단계: 로그인 여부 확인 ─────────────────────────
        // 조건 1: session == null → 세션 자체가 없음 (한 번도 로그인 안 한 사용자)
        // 조건 2: session.getAttribute("loginMember") == null
        //         → 세션은 있지만 로그인 정보("loginMember")가 없음
        //         (세션이 만료되었거나 로그아웃한 경우)
        // || (OR 연산자): 둘 중 하나라도 true이면 전체가 true
        if (session == null || session.getAttribute("loginMember") == null) {
            // ── 3단계: 로그인 페이지로 리다이렉트 ────────────
            // response.sendRedirect("/members/login"):
            //   브라우저에게 "/members/login" 주소로 이동하라고 지시합니다.
            //   비유: "티켓이 없으시네요. 매표소(로그인 페이지)로 가주세요."
            // 리다이렉트 = 브라우저가 자동으로 새로운 URL로 이동하는 것
            response.sendRedirect("/members/login");

            // false를 반환하면 이 요청은 여기서 중단됩니다.
            // Controller까지 도달하지 못합니다.
            return false;
        }

        // ── 4단계: 로그인 확인 완료 → 통과 ──────────────────
        // true를 반환하면 요청이 Controller까지 정상적으로 전달됩니다.
        // 비유: "티켓 확인 완료! 들어가세요."
        return true;
    }
}
