package com.fit;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication

// Spring Boot가 시작될 때 application-secret.properties 파일의 내용도 함께 로드, 로드된 프로퍼티 값들은 @Value 어노테이션 등을 통해 사용
@PropertySource("classpath:application-secret.properties") 
public class EdmsApplication {

	public static void main(String[] args) {
		SpringApplication.run(EdmsApplication.class, args);
	}

}
