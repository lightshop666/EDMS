package com.fit.vo;

import java.util.*;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)		//DTO에 없는 필드 무시
public class ProgramDetailDTO {
	private int programRegistNo;		//프로그램등록번호
	private String progrmSj;			//봉사제목
	private int progrmSttusSe;			//모집상태	1:모집대기 2:모집중 3:모집완료
	private Date progrmBgnde;			//봉사시작일자
	private Date progrmEndde;			//봉사종료일자
	private String actBeginTm;			//봉사시작시간
	private String actEndTm;			//봉사종료시간
	private Date noticeBgnde;			//모집시작일
	private Date noticeEndde;			//모집종료일
	private int rcritNmpr;				//모집인원
	private String actWkdy;				//활동요일	1111100(월,화,수,목,금,토,일)
	private String srvcClCode;			//봉사분야
	private String adultPosblAt;		//성인가능여부
	private String yngbgsPosblAt;		//청소년가능여부
	private String grpPosblAt;			//단체가능여부
	private String mnnstNm;				//모집기관(주관기관명)
	private String nanmmbyNm;			//등록기관(나눔주체명)
	private String actPlace;			//봉사장소
	private String nanmmbyNmAdm;		//담당자명
	private String telno;				//전화번호
	private String fxnum;				//FAX번호
	private String postAdres;			//담당자 주소
	private String email;				//이메일
	private String progrmCn;			//내용
	
	
    private int numOfRows;
    private int pageNo;
    private String resultCode;
    private String resultMsg;
    private int appTotal;
    private String sidoCd;
    private String gugunCd;
    private int totalCount;
}
