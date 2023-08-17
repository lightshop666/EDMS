package com.fit.vo;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Utility {
	private int utilityNo;
	private String utilityCategory;
	private String utilityName;
	private String utilityInfo;
	private String createdate;
	private String updatedate;
	
	// DTO 타입으로 form으로부터 단일파일 입력값을 받기위한 객체
	private MultipartFile singlepartFile;
	// 하나의 쿼리로 join하여 리스트로 넣기 위해 UtilityFile 추가
	private String utilityOriFilename;
	private String utilitySaveFilename;
	private String utilityFiletype;
	private String utilityPath; 
}
