package com.fit.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface SalesChartMapper {
	// 차트 출력을 위한 매출보고서 조회
	
	List<Map<String, Object>> getSalesDraftForChart(String startDate, String endDate); // 기간별 조회
	
	List<Map<String, Object>> getSalesDraftForMorrisChart(String startDate, String endDate); // 기간별 평균 목표달성률 조회
	
	List<Map<String, Object>> getRecentSalesDraftForChart(); // 가장 최근 1건 조회
}
