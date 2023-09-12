package com.fit;


import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
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
				.addPathPatterns("/reservation/**")
				.addPathPatterns("/schedule/**")
				.addPathPatterns("/utility/**")
				.addPathPatterns("/draft/**")
				.addPathPatterns("/chatMessage")
				.addPathPatterns("/header")
				.addPathPatterns("/mainmenu")
				.addPathPatterns("/home");
	}
	
	
    // 404 처리를 위한 ViewController 등록
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // 404 에러 발생시 /error/404 URL로 리다이렉트하도록 설정
        registry.addViewController("/error/404").setViewName("error/404");
    }
    
}