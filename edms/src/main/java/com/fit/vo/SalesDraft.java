package com.fit.vo;

import lombok.Data;

@Data
public class SalesDraft {
	private int documentNo;
	private int approvalNo;
	private String docTitle;
	private String salesDate; // 기준년월 YYYY-MM-00
	private String updatedate;
	private String createdate;
}