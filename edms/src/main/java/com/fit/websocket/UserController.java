package com.fit.websocket;

import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class UserController {
	@Autowired
	private UserService userService;
	
	@GetMapping("/userList")
	public ConcurrentHashMap<String, Object> getConnectedUsers() {
	    ConcurrentHashMap<String, Object> users = userService.getConnectedUsers();
	    log.debug(CC.WOO + "유저리스트아작스.users : " + users + CC.RESET);
	    return users;
	}
}

