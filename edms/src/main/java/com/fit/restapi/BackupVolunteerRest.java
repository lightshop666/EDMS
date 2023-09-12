package com.fit.restapi;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONObject;
import org.json.XML;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.fit.CC;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class BackupVolunteerRest {
	
	@Value("${myapi.volunteerKey}")
    private String serviceKey;
	
	// 1. 서울시 금천구의 봉사 정보 리스트를 조회
	@GetMapping("/abcdefgetVltrAreaListApi")
    public String getVltrAreaListApi() {
		// 결과를 저장할 StringBuffer 및 JSON 문자열 초기화
		StringBuffer result = new StringBuffer();
        String jsonPrintString = null;
        
        try {
        	// 봉사 정보를 조회하기 위한 API URL 생성
        	String apiUrl = "http://openapi.1365.go.kr/openapi/service/rest/VolunteerPartcptnService/getVltrAreaList?" +
        			"serviceKey=" + serviceKey +
                    "&schSido=6110000" + // 서울시 지역코드 // 값 고정
                    "&schSign1=3170000" + // 금천구 지역코드 // 값 고정
                    "&numOfRows=50" ; // 최대 50개의 정보를 조회합니다. 임의의 값으로 변경 가능
        	
        	// API에 연결하기 위한 URL 객체 생성
            URL url = new URL(apiUrl);
            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.connect();
            
            // API 응답을 읽기 위한 스트림 설정
            BufferedInputStream bufferedInputStream = new BufferedInputStream(urlConnection.getInputStream());
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(bufferedInputStream, "UTF-8"));
            String returnLine = null;
            while((returnLine = bufferedReader.readLine()) != null) {
            	// API 응답 데이터를 StringBuilder에 추가
                result.append(returnLine);
            }
            
            // API 응답 데이터를 XML에서 JSON으로 변환
            JSONObject jsonObject = XML.toJSONObject(result.toString());
            jsonPrintString = jsonObject.toString();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        // 디버깅
        log.debug(CC.HE + "VolunteerRest.getVltrAreaListApi() result : " + jsonPrintString + CC.RESET);
        
        return jsonPrintString;
	}
	
	// 2. 위에서 조회한 progrmRegistNo로 해당 봉사정보의 상세 정보 조회
	// 상세 정보에 지도에 마커를 찍을 때 필요한 좌표값이 포함되어 있습니다.
	@GetMapping("/abcdefgetVltrPartcptnItem")
	public String getVltrPartcptnItem(int progrmRegistNo) {
		StringBuffer result = new StringBuffer();
        String jsonPrintString = null;
        
        try {
        	String apiUrl = "http://openapi.1365.go.kr/openapi/service/rest/VolunteerPartcptnService/getVltrPartcptnItem?" +
        			"serviceKey=" + serviceKey +
                    "&progrmRegistNo=" + progrmRegistNo; // 프로그램등록번호
        	
            URL url = new URL(apiUrl);
            HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
            urlConnection.connect();
            BufferedInputStream bufferedInputStream = new BufferedInputStream(urlConnection.getInputStream());
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(bufferedInputStream, "UTF-8"));
            String returnLine;
            while((returnLine = bufferedReader.readLine()) != null) {
                result.append(returnLine);
            }

            JSONObject jsonObject = XML.toJSONObject(result.toString());
            jsonPrintString = jsonObject.toString();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        log.debug(CC.HE + "VolunteerRest.getVltrPartcptnItem() result : " + jsonPrintString + CC.RESET);
        
        return jsonPrintString;
	}
}
