package com.fit.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fit.mapper.SalesChartMapper;

@Service
@Transactional
public class SalesChartService {
	
	@Autowired
	private SalesChartMapper salesChartMapper;
	
	// 기간별 조회
	public List<Map<String, Object>> getSalesDraftForChart(String startDate, String endDate) {
		return salesChartMapper.getSalesDraftForChart(startDate, endDate);
	}
	
	// 기간별 평균 목표달성률 조회
	public List<Map<String, Object>> getSalesDraftForMorrisChart(String startDate, String endDate) {
		return salesChartMapper.getSalesDraftForMorrisChart(startDate, endDate);
	}
	
	// 가장 최근 데이터 1건 조회
	public List<Map<String, Object>> getRecentSalesDraftForChart() {
		return salesChartMapper.getRecentSalesDraftForChart();
	}
}
