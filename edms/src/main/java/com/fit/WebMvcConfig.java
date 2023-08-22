package com.fit;

import java.util.concurrent.TimeUnit;

import org.springframework.context.annotation.Configuration;
import org.springframework.http.CacheControl;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.fit.interceptor.AuthInterceptor;

//스프링 설정을 위한 클래스
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

	// 인터셉터 설정을 추가하기 위한 메서드 오버라이드
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
        // AuthInterceptor 클래스를 새로운 인스턴스로 생성하여 인터셉터로 등록
		registry.addInterceptor(new AuthInterceptor())
				// 인터셉터가 적용될 URL 패턴 설정 (모든 URL에 적용)
				.addPathPatterns("/**")
				// 제외될 URL 패턴 설정 (로그인 페이지는 인터셉터가 적용되지 않음)
				.excludePathPatterns("/login")
				.excludePathPatterns("/member/addMember")
				.excludePathPatterns("/checkEmpNo") // ajax 링크도 예외처리를 해주어야 한다
				.excludePathPatterns("/sendMassage")
				.excludePathPatterns("/sendPrivateMessage/*");
	}
	
	@Override
	public void addResourceHandlers(final ResourceHandlerRegistry registry) {
	    // 정적 자원 요청을 처리하기 위한 ResourceHandler를 추가
		
		registry.addResourceHandler("/**") // 어떤 URL 요청이든 처리하도록 설정
				.addResourceLocations("classpath:/templates/", "classpath:/static/") // 정적 자원을 클래스 패스 내의 /templates/ 폴더에서 찾도록 지정
				.setCacheControl(CacheControl.maxAge(10, TimeUnit.MINUTES)); // 캐시 컨트롤 설정을 추가합니다.
		/*
		브라우저 캐시를 활성화하고, 캐시가 유효한 기간을 10분으로 설정했습니다. 
		이렇게 설정하면 클라이언트(브라우저)는 정적 자원을 캐시로 저장하고, 10분 동안 해당 캐시를 사용할 것입니다. 
		이렇게 하면 웹 애플리케이션의 성능을 향상시킬 수 있습니다.
		 */
	}

}