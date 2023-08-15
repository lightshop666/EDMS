package com.fit.vo;

import lombok.Data;

@Data
public class Schedule {
	private int scheduleNo;
	private String scheduleStartTime;
	private String scheduleEndTime;
	private String scheduleContent;
	private String createdate;
}
