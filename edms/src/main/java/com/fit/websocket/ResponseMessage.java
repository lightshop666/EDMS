package com.fit.websocket;

//WebSocket 통신에서 사용할 응답 메시지 객체
public class ResponseMessage {
    private String content;
    private String webSocketId;

    public ResponseMessage(String content, String webSocketId) {
        this.setContent(content);
        this.setWebSocketId(webSocketId);
    }
    public ResponseMessage(String content) {
        this.setContent(content);
    }

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getWebSocketId() {
		return webSocketId;
	}

	public void setWebSocketId(String webSocketId) {
		this.webSocketId = webSocketId;
	}

}
