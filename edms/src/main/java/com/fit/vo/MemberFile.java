package com.fit.vo;

import lombok.Data;

@Data
public class MemberFile {
	private int memberFileNo;
	private int empNo;
	private String fileCategory;
	private String memberOriFileName;
	private String memberSaveFileName;
	private String memberFiletype;
	private String memberPath;
	private String createdate;
	private String updatedate;
}
