package com.fit.websocket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class NotificationService {
	@Autowired
    private SimpMessagingTemplate messagingTemplate;

    
    public void sendGlobalNotification() {
        ResponseMessage message = new ResponseMessage("Global Notification");
		log.debug(CC.WOO + "노티피케이션서비스.알림보내기 message :  " + message + CC.RESET);

        messagingTemplate.convertAndSend("/topic/globalNotifications", message);
    }

}
