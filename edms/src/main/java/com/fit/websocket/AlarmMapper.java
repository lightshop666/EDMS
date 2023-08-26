package com.fit.websocket;

import com.fit.vo.Alarm;

public interface AlarmMapper {
	//알림 저장
	int insertAlarm(Alarm alarm);
}
