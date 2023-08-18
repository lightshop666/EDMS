package com.fit.vo;

import lombok.Data;

@Data
public class BoardFile {
	private int boardFileNo;
    private int boardNo;
    private String boardOriFileName;
    private String boardSaveFileName;
    private String boardFileType;
    private String boardPath;
    private String createdate;
    private String updatedate;
}
