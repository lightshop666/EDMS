package com.fit.websocket;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import com.fit.CC;
import com.fit.vo.Alarm;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AlarmService {

    private final AlarmMapper alarmMapper;
    private final SimpMessagingTemplate messagingTemplate;
   
    @Autowired
    public AlarmService(AlarmMapper alarmMapper, SimpMessagingTemplate messagingTemplate) {
        this.alarmMapper = alarmMapper;
        this.messagingTemplate = messagingTemplate;
    }

    //유저에게 알림을 보내주는 서비스 
	//사용자ID, 알림 내용 enum '기안알림','일정알림','공지알림', 구독 주제 (/topic/draftAlarm)
	public void sendAlarmToUser(int empNo,String alarmContent, String prefixContent) {
	    // 알림 정보를 생성
	    Alarm alarm = new Alarm();
	    alarm.setEmpNo(empNo);
	    alarm.setAlarmContent(alarmContent);
	    alarm.setPrefixContent(prefixContent);
	    alarm.setAlarmCheck("N");
	    // 알림을 DB에 저장
	    alarmMapper.insertAlarm(alarm);
log.debug(CC.WOO +"알람서비스.알람발송 :  " + alarm + CC.RESET);

	
        // WebSocket을 통해 사용자에게 알림을 보냅니다.
		// 이 주제에 구독한 특정 사용자만 이 메시지를 받게 됩니다.
		// "/user/prefixContent(=/topic/draftAlarm)"와 같은 형식으로 메시지가 전송
		messagingTemplate.convertAndSendToUser(String.valueOf(empNo), prefixContent, alarm);
	    
     }
    
	
}
