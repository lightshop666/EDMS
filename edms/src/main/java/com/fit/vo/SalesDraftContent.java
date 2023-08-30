package com.fit.vo;

import lombok.Data;

@Data
public class SalesDraftContent {
	private int contentNo;
	private int documentNo;
	private String productCategory; // 스탠드, 무드등, 실내조명, 실외조명, 포인트조명
	private double targetSales; // 목표액
	private double previousSales; // 전월매출액
	private double currentSalse; // 당월매출액
	private double targetRate; // 목표달성률
	private String createdate;
	private String udpatedate;
}
