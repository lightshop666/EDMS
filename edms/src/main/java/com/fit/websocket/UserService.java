package com.fit.websocket;

import org.springframework.stereotype.Service;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class UserService {
	//유저리스트 싱글톤으로 관리

	private final ConcurrentHashMap<String, Object> connectedUsers = new ConcurrentHashMap<>();
	
	
	public void addUser(String sessionId, Object user) {
	    connectedUsers.put(sessionId, user);
	}
	
	public ConcurrentHashMap<String, Object> getConnectedUsers() {
	    return connectedUsers;
	}
	
	public void remove(String sessionId, Object user) {
		connectedUsers.remove(sessionId, user);	
	};

}
