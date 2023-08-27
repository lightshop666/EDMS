package com.fit.websocket;

import org.apache.ibatis.annotations.Mapper;

import com.fit.vo.Alarm;

@Mapper
public interface AlarmMapper {
	//알림 저장
	int insertAlarm(Alarm alarm);
}
