package com.fit.websocket;

import com.fit.CC;
import com.sun.security.auth.UserPrincipal;

import lombok.extern.slf4j.Slf4j;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.support.DefaultHandshakeHandler;

import java.security.Principal;
import java.util.Map;
import java.util.UUID;

@Slf4j
public class UserHandshakeHandler extends DefaultHandshakeHandler {
    private final Logger LOG = LoggerFactory.getLogger(UserHandshakeHandler.class);

    @Override
    protected Principal determineUser(ServerHttpRequest request, WebSocketHandler wsHandler, Map<String, Object> attributes) {
        // 랜덤한 사용자 ID 생성
    	final String randomId = UUID.randomUUID().toString();

        LOG.info("User with ID '{}' opened the page", randomId);
        log.debug(CC.WOO + "이 페이지에서의 유저 ID :  " + randomId + CC.RESET);

        // 생성한 랜덤 ID를 사용자의 Principal로 반환
        return new UserPrincipal(randomId);
    }
}
