package com.fit.websocket;

//WebSocket 통신에서 사용할 응답 메시지 객체
public class ResponseMessage {
	private String name;		// 사용자 이름
	private String content;		// 응답 메시지의 내용을 저장할 변수
	
	public ResponseMessage() {
	}

	public ResponseMessage(String content) {
		this.content = content;
	}	

	public ResponseMessage(String name, String content) {
		this.name = name;
		this.content = content;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	
}
