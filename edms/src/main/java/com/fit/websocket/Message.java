package com.fit.websocket;

//WebSocket 통신에서 사용할 메시지 객체
public class Message {
	private String name;
	private String messageContent;// 메시지의 내용을 저장할 변수
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMessageContent() {
		return messageContent;
	}
	public void setMessageContent(String messageContent) {
		this.messageContent = messageContent;
	}
	

}