package com.fit.websocket;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Alarm;

@Mapper
public interface AlarmMapper {
	//알림 저장
	int insertAlarm(Alarm alarm);
	
	//미확인 알림 검색
	Map<String, Alarm> selectNCked(int empNo);
	
	//알림 확인 N->Y
	int updateAlarmCK(int alarmNo);
	
}
