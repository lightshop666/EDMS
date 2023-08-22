package com.fit.websocket;

//WebSocket 통신에서 사용할 응답 메시지 객체
public class ResponseMessage {
	private String content;		// 응답 메시지의 내용을 저장할 변수
	
	public ResponseMessage() {
	}

	public ResponseMessage(String content) {
		this.content = content;
	}	

	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
}
