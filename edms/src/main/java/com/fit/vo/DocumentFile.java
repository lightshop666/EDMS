package com.fit.vo;

import lombok.Data;

@Data
public class DocumentFile {
	private int docFileNo;
	private int approvalNo;
	private String docOriFilename;
	private String docSaveFilename;
	private String docFiletype;
	private String docPath;
	private String createDate;
	private String updateDate;
}
