package com.fit.vo;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class MemberFileList {
	private int memberFileNo;
	private int empNo;
	private String fileCategory;
	private String memberOriFileName;
	private String memberSaveFileName;
	private String memberFiletype;
	private String memberPath;
	private String createdate;
	private String updatedate;
	private List<MultipartFile> multipartFile; // 여러개의 파일을 처리하기 위해 List 형으로 지정
}
