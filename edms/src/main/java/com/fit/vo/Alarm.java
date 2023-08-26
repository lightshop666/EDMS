package com.fit.vo;

import lombok.Data;

@Data
public class Alarm {
	private int alarmNo;				//pk
	private int empNo;					//회원 ID
	private String alarmContent;		//알림 내용 enum '기안알림','일정알림','공지알림'
	private String prefixContent;		//웹소켓 주제 (/topic)
	private String alarmDate;			//알림 일시
	private String alarmCheck;			//알림 읽은 여부 enum Y N
}
