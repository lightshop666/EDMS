package com.fit.restapi;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;
import com.fit.service.VolunteerService;
import com.fit.vo.ProgramDetailDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class VolunteerRest {
	//API호출하고 정리한 서비스 레이어 주입
    @Autowired
    private VolunteerService volunteerService;
	
	// 1. 서울시 금천구의 봉사 정보 리스트를 조회
    @GetMapping("/getVltrAreaListApi")
    public String getVltrAreaListApi() {
        log.debug(CC.JUNG + " 봉사정보RestController.getVltrAreaListApi :  " + volunteerService.getVltrAreaListApi().toString()  + CC.RESET);
        return volunteerService.getVltrAreaListApi().toString();
    }
    
	
	// 2. 위에서 조회한 progrmRegistNo로 해당 봉사정보의 상세 정보 조회
	// 상세 정보에 지도에 마커를 찍을 때 필요한 좌표값이 포함되어 있습니다.
	@GetMapping("/getVltrPartcptnItem")
	public String getVltrPartcptnItem(int progrmRegistNo) {
        log.debug(CC.JUNG + " 봉사정보RestController.getVltrPartcptnItem :  " + volunteerService.getVltrPartcptnItem(progrmRegistNo).toString()  + CC.RESET);
        return volunteerService.getVltrPartcptnItem(progrmRegistNo).toString();
	}
	
	// 3. 1+2 매핑
    @GetMapping("/vltrDetailsList")
    public ResponseEntity<List<ProgramDetailDTO>> getDetails() {
        List<ProgramDetailDTO> details = volunteerService.getAllDetailedVolunteerInfo();
        return ResponseEntity.ok(details);
    }
	
	
}
