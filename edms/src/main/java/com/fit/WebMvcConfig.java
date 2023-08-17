package com.fit;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
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
				.excludePathPatterns("/member/addMember");
	}
}