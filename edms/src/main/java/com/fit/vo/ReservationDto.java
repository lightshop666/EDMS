package com.fit.vo;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.Data;

@Data
public class ReservationDto {
	private int reservationNo;
	private int empNo;
	private int utilityNo;
	private String reservationDate;
	private String reservationTime;
	private String createdate;
	
	// DB 테이블과는 일치하지 않는 확장컬럼
	private String utilityCategory;
	private String utilityName;
	private String empName;
	
	// DB에 저장된 형식을 view 페이지 달력에서 fullcalendar에 사용할 형식으로 변환하는 메서드
	// 예약 시작 시간을 반환하는 메서드
    public String getReservationStartTime() {
    	// 예약시간이 있을경우 
        if (reservationTime != null) {
        	// 1. reservationTime을 "~"를 기준으로 분리(split) 결과로 ["08:00", "18:00"]과 같은 문자열 배열이 생성
        	// 2. 배열에서 첫 번째 요소를 선택 여기서는 "08:00"이 첫 번째 요소
        	// 3. 선택한 요소 양쪽의 공백(whitespace)를 제거 여기서는 공백이 없기 때문에 "08:00"이 그대로 반환
            return reservationTime.split("~")[0].trim();
        }
        // reservationTime이 null인 경우 null을 반환합니다.
        return null;
    }

    // 예약 종료 시간을 반환하는 메서드
    public String getReservationEndTime() {
        if (reservationTime != null) {
        	// 1. reservationTime을 "~"를 기준으로 분리(split) 결과로 ["08:00", "18:00"]과 같은 문자열 배열이 생성
        	// 2. 배열에서 첫 번째 요소를 선택 여기서는 "18:00"이 두 번째 요소
        	// 3. 선택한 요소 양쪽의 공백(whitespace)를 제거 여기서는 공백이 없기 때문에 "18:00"이 그대로 반환
            return reservationTime.split("~")[1].trim();
        }
        return null;
    }
	
	// 시작 날짜와 시간을 반환하는 메서드
    public String getStartDateTime() {
    	// 예약 시간을 가져온다.
        String startTime = getReservationStartTime();
        // 예약 날짜와 시작 시간이 있다면
        if (reservationDate != null && startTime != null) {
        	// 문자열로 된 날짜와 시간 정보를 LocalDateTime 객체로 변환
            LocalDateTime startDateTime = LocalDateTime.parse(
                    reservationDate.substring(0, 10) + " " + startTime,
                    DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
            
            // LocalDateTime 객체를 ISO_LOCAL_DATE_TIME 형식의 문자열로 변환하여 반환
            return startDateTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        }
        return null;
    }

    // 종료 날짜와 시간을 반환하는 메서드
    public String getEndDateTime() {
        String endTime = getReservationEndTime();
        if (reservationDate != null && endTime != null) {
            LocalDateTime endDateTime = LocalDateTime.parse(
                    reservationDate.substring(0, 10) + " " + endTime,
                    DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
            return endDateTime.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        }
        return null;
    }
}
