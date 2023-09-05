package com.fit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Board {
	private int boardNo;
	private int empNo;
	private String boardCategory;
	private String boardTitle;
	private String boardContent;
	private String topExposure;
	private String createdate;
	private String updatedate;
	
	// table 속성 X, 입력폼 속성 O -> DTO와 Board.class(도메인)을 분리해 사용가능
	private List<MultipartFile> multipartFile; // 여러개의 파일을 처리하기 위해 List 형으로 지정
	
}
