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

    
    public void sendGlobalNotification(String webSocketId) {
        ResponseMessage message = new ResponseMessage("Global Notification", webSocketId);
		log.debug(CC.WOO + "노티피케이션서비스.알림보내기 message :  " + message + CC.RESET);

        messagingTemplate.convertAndSend("/topic/globalNotifications", message);
    }
    
    //개별 알림
    public void sendPrivateNotification(String webSocketId) {
        ResponseMessage message = new ResponseMessage("Private Notification", webSocketId);
		log.debug(CC.WOO + "노티피케이션서비스.프라이빗 알림보내기 webSocketId:  " + webSocketId + ", 메시지 : " + message + CC.RESET);

        messagingTemplate.convertAndSendToUser(webSocketId,"/topic/privateNotifications", message);
    }

}
