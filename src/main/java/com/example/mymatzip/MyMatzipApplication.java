/*
 * ============================================================================
 *  파일명    : MyMatzipApplication.java
 *  위치      : com.example.mymatzip (최상위 패키지)
 *  역할      : 스프링 부트 애플리케이션의 "시작점" (= 프로그램의 전원 버튼)
 * ============================================================================
 *
 *  ■ 비유
 *    자동차의 시동 키와 같습니다.
 *    이 파일의 main() 메서드를 실행하면 스프링 부트 엔진이 켜지고,
 *    웹 서버(Tomcat)가 시작되며, 브라우저에서 http://localhost:8080 으로
 *    접속할 수 있게 됩니다.
 *
 *  ■ MVC에서의 위치
 *    MVC(Model-View-Controller) 어디에도 속하지 않는 "인프라" 파일입니다.
 *    애플리케이션 전체를 부팅(시작)하는 역할만 담당합니다.
 *
 *  ■ WAR 배포 지원
 *    JSP 파일은 JAR(자바 압축 파일) 안에서는 동작하지 않기 때문에,
 *    WAR(웹 애플리케이션 압축 파일) 형태로 배포해야 합니다.
 *    SpringBootServletInitializer를 상속(extends)하면
 *    외부 Tomcat 서버에 WAR로 배포할 수 있습니다.
 *
 *  ■ URL 매핑
 *    이 파일 자체는 URL을 처리하지 않습니다.
 *    URL 처리는 Controller 파일들이 담당합니다.
 * ============================================================================
 */

// ── 패키지 선언 ──────────────────────────────────────────────
// 이 파일이 속하는 폴더(패키지) 경로를 선언합니다.
// 자바에서는 폴더 구조와 패키지 선언이 반드시 일치해야 합니다.
package com.example.mymatzip;

// ── import 문 (외부 라이브러리 가져오기) ─────────────────────
// import는 다른 파일에 있는 클래스를 이 파일에서 쓸 수 있게 가져오는 것입니다.
// 비유: 요리할 때 필요한 재료를 냉장고에서 꺼내오는 것과 같습니다.

// SpringApplication: 스프링 부트 애플리케이션을 실행(run)하는 핵심 클래스
import org.springframework.boot.SpringApplication;

// @SpringBootApplication: 이 클래스가 스프링 부트의 시작점임을 알려주는 어노테이션(표시)
import org.springframework.boot.autoconfigure.SpringBootApplication;

// SpringApplicationBuilder: WAR 배포 시 애플리케이션 설정을 빌드(조립)하는 도구
import org.springframework.boot.builder.SpringApplicationBuilder;

// SpringBootServletInitializer: WAR 파일로 배포할 때 필요한 부모 클래스
// 이것을 상속받아야 외부 Tomcat 서버에서 실행할 수 있습니다.
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

// ── @SpringBootApplication 어노테이션 ───────────────────────
// 이 어노테이션 하나가 아래 3가지 역할을 동시에 수행합니다:
//   1) @SpringBootConfiguration : 이 클래스가 설정 파일임을 표시
//   2) @EnableAutoConfiguration : 스프링 부트가 자동으로 필요한 설정을 해줌
//      (예: 데이터베이스 연결, 웹 서버 설정 등을 자동으로 잡아줌)
//   3) @ComponentScan : 이 패키지와 하위 패키지의 모든 클래스를 자동으로 찾아서 등록
//      (예: @Controller, @Service, @Repository 등이 붙은 클래스를 스프링이 관리)
@SpringBootApplication
// ── 클래스 선언 ─────────────────────────────────────────────
// public: 어디서든 접근 가능
// class: 자바의 기본 설계 단위 (= 붕어빵 틀)
// MyMatzipApplication: 이 클래스의 이름 (파일명과 동일해야 함)
// extends SpringBootServletInitializer: SpringBootServletInitializer를 상속받음
//   → WAR 파일로 외부 Tomcat에 배포할 수 있게 됨
public class MyMatzipApplication extends SpringBootServletInitializer {

    // ── configure 메서드 ────────────────────────────────────
    // 역할: 외부 Tomcat 서버에 WAR로 배포할 때 호출되는 설정 메서드
    // @Override: 부모 클래스(SpringBootServletInitializer)의 메서드를 재정의(덮어쓰기)
    // 매개변수: application → 애플리케이션 설정을 담는 빌더 객체
    // 반환값: SpringApplicationBuilder → 이 애플리케이션의 시작 클래스를 설정한 빌더
    // 비유: "이 WAR 파일의 주인은 MyMatzipApplication이야" 라고 알려주는 것
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        // application.sources(...)에 이 클래스를 넘겨서
        // "이 클래스가 애플리케이션의 시작점이다"라고 등록합니다.
        return application.sources(MyMatzipApplication.class);
    }

    // ── main 메서드 (프로그램 시작점) ────────────────────────
    // 자바 프로그램은 항상 main 메서드에서 시작됩니다.
    // public: 외부에서 접근 가능 (JVM이 호출해야 하므로)
    // static: 객체를 만들지 않아도 실행 가능 (프로그램 시작 전이므로 객체가 없음)
    // void: 반환값 없음
    // String[] args: 프로그램 실행 시 전달되는 인자들 (보통 비어 있음)
    // 비유: 자동차의 시동 버튼을 누르는 것과 같습니다.
    public static void main(String[] args) {
        // SpringApplication.run()을 호출하면:
        //   1) 내장 Tomcat 웹 서버가 시작됨
        //   2) 스프링 컨테이너(= 객체 관리자)가 생성됨
        //   3) @Component, @Controller, @Service 등이 붙은 클래스들이 자동 등록됨
        //   4) 설정 파일(application.properties)이 읽혀짐
        //   5) http://localhost:8080 으로 접속 가능해짐
        // 첫 번째 인자: 시작 클래스 (이 클래스 자신)
        // 두 번째 인자: main 메서드가 받은 인자들을 그대로 전달
        SpringApplication.run(MyMatzipApplication.class, args);
    }
}
