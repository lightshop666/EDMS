package com.fit.restapi;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;
import com.fit.service.SalesChartService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@CrossOrigin
@RestController
public class ChartRest {
	@Autowired
	private SalesChartService salesChartService;
	
	// LocalDate 객체를 yyyy-MM-01 형식의 String 문자열로 변환하는 메서드
	private String modifyStringDate(LocalDate date) {
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		String formattedDate = date.format(formatter);
		String modifiedString = formattedDate.replaceAll("(.{2})$", "01"); // 문자열의 뒤에서 2글자를 "01"로 대체
		
		return modifiedString;
	}
	
	// 상품 카테고리별 최근 3개월 매출달성률 조회 (bar 차트)
	@GetMapping("/getSalesDraftForBarChart")
	public List<Map<String, Object>> getSalesDraftForBarChart() {
		// 현재 날짜 객체 생성
		LocalDate today = LocalDate.now();
		// 3개월 전 객체 생성
		LocalDate threeMonthsAgo = today.minusMonths(3);
		
		// String 문자열로 변환
		String todayString = modifyStringDate(today);
		String threeMonthsAgoString = modifyStringDate(threeMonthsAgo);
		log.debug(CC.HE + "ChartRest.getSalesDraftForBarChart() todayString : " + todayString + CC.RESET);
		log.debug(CC.HE + "ChartRest.getSalesDraftForBarChart() threeMonthsAgoString : " + threeMonthsAgoString + CC.RESET);
		
		// 서비스 호출
		List<Map<String, Object>> resultList = salesChartService.getSalesDraftForChart(threeMonthsAgoString, todayString);
		log.debug(CC.HE + "ChartRest.getSalesDraftForBarChart() resultList : " + resultList + CC.RESET);
		
		return resultList;
	}
	
	// 최근 1개월의 상품 카테고리별 매출달성률 조회 (donut 차트)
	@GetMapping("/getSalesDraftForDonutChart")
	public List<Map<String, Object>> getSalesDraftForDonutChart() {
		List<Map<String, Object>> resultList = salesChartService.getRecentSalesDraftForChart();
		log.debug(CC.HE + "ChartRest.getSalesDraftForDonutChart() resultList : " + resultList + CC.RESET);
		return resultList;
	}
	
	// 최근 1년의 상품 카테고리별 평균 목표달성률 조회(morris 차트)
	@GetMapping("/getSalesDraftForMorrisChart")
	public List<Map<String, Object>> getLastYearData() {
	    LocalDate now = LocalDate.now();
	    String startDate = modifyStringDate(now.minusYears(1).withDayOfMonth(1));  // 첫날
	    String endDate = modifyStringDate(now.withDayOfMonth(now.lengthOfMonth())); // 마지막날
	    
	    return salesChartService.getSalesDraftForMorrisChart(startDate, endDate);
	}
}
