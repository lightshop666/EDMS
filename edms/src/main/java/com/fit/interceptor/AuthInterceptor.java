package com.fit.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class AuthInterceptor extends HandlerInterceptorAdapter  {
/*
스프링에서 "빈"은 스프링 컨테이너에 의해 관리되는 객체를 의미
빈은 스프링의 핵심 개념 중 하나로, 스프링 컨테이너가 생성, 관리 및 주입해주는 객체. 
@Component 어노테이션은 이러한 빈으로 등록될 클래스를 표시하는 데 사용.
스프링은 @Component 어노테이션이 붙은 클래스를 스캔하여 자동으로 빈으로 등록.

HandlerInterceptorAdapter는 스프링 프레임워크에서 제공하는 클래스로, 핸들러 인터셉터를 구현하기 위해 사용.
핸들러 인터셉터는 스프링 MVC 프레임워크에서 컨트롤러의 메서드가 호출되기 전 또는 후에 추가적인 로직을 수행하도록 해주는 역할.
예를 들어, 요청 전에 로그인 여부를 체크하거나, 응답 후에 특정 작업을 수행하는 등의 기능을 핸들러 인터셉터를 통해 추가할 수 있습니다.

HandlerInterceptorAdapter는 추상 클래스로, 미리 정의된 메서드를 오버라이딩하여 원하는 로직을 구현. 
preHandle 메서드는 컨트롤러의 메서드가 호출되기 전에 실행되는 로직을 정의하는데 사용. 
예를 들어 인증 체크, 권한 검사 등의 작업을 이 메서드에서 수행할 수 있습니다. 

만약 preHandle에서 false를 반환하면 요청 처리가 중단되며, true를 반환하면 요청 처리가 계속 진행됩니다.
이렇게 HandlerInterceptorAdapter를 상속받은 클래스를 정의하면, 스프링 MVC 프레임워크에서 요청 처리의 여러 단계에서 해당 인터셉터의 로직이 적용됩니다. 
이렇게 함으로써 인터셉터를 통해 공통적인 로직을 중앙에서 관리하고, 중복 코드를 줄이며, 웹 애플리케이션의 보안, 인증, 로깅 등을 효과적으로 제어할 수 있습니다.
 */
	
	// 컨트롤러의 요청 처리 전에 호출되는 메서드
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		// 현재 세션 가져오기
		HttpSession session = request.getSession();
		// 세션에서 로그인된 사용자 아이디 가져오기
		Object loginMemberId = session.getAttribute("loginMemberId");
		
		// 로그인된 사용자 아이디가 없는 경우
		if (loginMemberId == null) {
log.debug(CC.WOO + "인터셉터.preHandle : loginMemberId가 널이면 로긴페이지로 리다이렉트  " + CC.RESET);
			// 로그인되지 않은 상태이므로 로그인 페이지로 리다이렉트
			response.sendRedirect("/goodeeFit/login");
			return false; // 요청 처리 중단
		}
		
		// 로그인된 사용자일 경우 요청 처리 계속 진행
		return true;
	}
}
