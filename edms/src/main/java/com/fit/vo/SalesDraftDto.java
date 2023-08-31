package com.fit.vo;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class SalesDraftDto {
	private int documentNo;
	private int approvalNo;
	private int deptNo;
	private String docTitle;
	private String salesDate; // 기준년월 YYYY-MM-00
	private String updatedate;
	private String createdate;
	
	// 파일첨부 DTO
	private List<MultipartFile> multipartFile;
	
	// 내역 DTO
	List<SalesDraftContent> salesDraftContentList;
}