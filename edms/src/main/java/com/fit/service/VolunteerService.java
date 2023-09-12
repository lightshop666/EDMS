package com.fit.service;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.XML;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fit.CC;
import com.fit.vo.ProgramDetailDTO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class VolunteerService {
	
	@Value("${myapi.volunteerKey}")
    private String serviceKey;
    
    public JSONObject getVltrAreaListApi() {
        // 결과를 저장할 StringBuffer 초기화
        StringBuffer result = new StringBuffer();
        
        try {
            // 봉사 정보를 조회하기 위한 API URL 생성
            String apiUrl = "http://openapi.1365.go.kr/openapi/service/rest/VolunteerPartcptnService/getVltrAreaList?" +
                    "serviceKey=" + serviceKey +
                    "&schSido=6110000" + // 서울시 지역코드
                    "&schSign1=3170000" + // 금천구 지역코드
                    "&numOfRows=50" ; // 최대 50개의 정보를 조회합니다.
            
			 // API에 연결하기 위한 URL 객체 생성
			 // 이 부분에서는 apiUrl 문자열을 사용하여 URL 객체를 생성. 이 URL 객체는 나중에 HttpURLConnection에 사용됩니다.
			 URL url = new URL(apiUrl);
			
			 // HttpURLConnection 객체를 생성. 이 객체를 사용하여 API에 연결.
			 HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();

			 // 이 단계에서 실제 네트워크 통신이 발생, API 서버에 연결 요청.
			 urlConnection.connect();
			
			 // API 응답을 읽기 위한 스트림 설정
			 // BufferedInputStream은 byte 단위로 데이터를 읽어들이는 스트림입니다.
			 // urlConnection.getInputStream()을 통해 API의 응답 데이터를 스트림 형태로 가져옵니다.
			 BufferedInputStream bufferedInputStream = new BufferedInputStream(urlConnection.getInputStream());
			
			 // BufferedReader는 문자(character) 단위로 데이터를 읽어들이는 스트림입니다.
			 // InputStreamReader를 사용하여 byte 스트림을 character 스트림으로 변환합니다.
			 // "UTF-8"은 문자 인코딩을 나타내며, 대부분의 웹 API 응답은 UTF-8로 인코딩됩니다.
			 BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(bufferedInputStream, "UTF-8"));
			
			 // 이 while 문은 API의 응답 데이터를 한 줄씩 읽어들입니다.
			 // 응답 데이터가 더 이상 없을 때까지 반복하여 읽어들이며, 각 줄을 result StringBuffer 객체에 추가합니다.
			 String returnLine = null;
			 while((returnLine = bufferedReader.readLine()) != null) {
			     result.append(returnLine);
			 }

            
            // API 응답 데이터를 XML에서 JSON으로 변환
            JSONObject jsonObject = XML.toJSONObject(result.toString());

            // 디버깅
            //log.debug(CC.HE + "봉사서비스.getVltrAreaListApi() result : " + jsonObject + CC.RESET);
            // API 응답 데이터를 XML에서 JSONObject으로 변환
            return jsonObject;
            
        } catch (Exception e) {
            log.debug(CC.WOO + " 봉사정보 에러로 인한 캐치문 "  + CC.RESET);
            return new JSONObject(); // 빈 JSON 객체 반환
        }
    }
    
    
    
	// 2. 위에서 조회한 progrmRegistNo로 해당 봉사정보의 상세 정보 조회
	// 상세 정보에 지도에 마커를 찍을 때 필요한 좌표값이 포함되어 있습니다.
	public JSONObject getVltrPartcptnItem(int progrmRegistNo) {
		// 결과를 저장할 StringBuffer 초기화
		StringBuffer result = new StringBuffer();
		
		try {
		    // API 호출 URL 생성. 이 URL에는 프로그램 등록 번호를 포함하여 봉사 정보의 상세 데이터를 가져옵니다.
		    String apiUrl = "http://openapi.1365.go.kr/openapi/service/rest/VolunteerPartcptnService/getVltrPartcptnItem?" +
		    				"serviceKey=" + serviceKey +
		                   "&progrmRegistNo=" + progrmRegistNo;
		    
		    // API에 연결하기 위한 URL 객체 생성
		    URL url = new URL(apiUrl);
		    // HttpURLConnection 객체로 URL에 연결을 시도합니다.
		    HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
		    urlConnection.connect();
		    
		    // API 응답 데이터를 스트림으로 읽어옵니다.
		    BufferedInputStream bufferedInputStream = new BufferedInputStream(urlConnection.getInputStream());
		    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(bufferedInputStream, "UTF-8"));
		    
		    String returnLine;
		    while((returnLine = bufferedReader.readLine()) != null) {
		        result.append(returnLine);
		    }
		
		    // 응답 데이터(XML 형식)를 JSON 형식으로 변환합니다.
		    JSONObject jsonObject = XML.toJSONObject(result.toString());
            // 디버깅
            //log.debug(CC.HE + "봉사서비스.getVltrAreaListApi() result : " + jsonObject + CC.RESET);
            return jsonObject;
		    
		} catch (Exception e) {
	        log.debug(CC.WOO + " 봉사정보 에러로 인한 캐치문 " + CC.RESET, e);
            return new JSONObject(); // 빈 JSON 객체 반환
		}
	}
	
	
	// 지역정보 API + 상세 정보 API 매핑	
	public List<ProgramDetailDTO> getAllDetailedVolunteerInfo() {
	    List<ProgramDetailDTO> detailedInfoList = new ArrayList<>();
	    ObjectMapper jsonMapper = new ObjectMapper();

	    try {
	        // 1. 금천구의 봉사 정보 목록 가져오기
	        JSONObject areaList = getVltrAreaListApi();
	        //log.debug(CC.WOO + " 봉사서비스.ProgramDetailDTO getVltrAreaListApi() : "  + areaList + CC.RESET);

	        /*
	        봉사정보 API JSON 값 구조
	        - response
			  |- body
			     |- items
			        |- item (배열)
	         */
	        JSONArray items = areaList.getJSONObject("response").getJSONObject("body").getJSONObject("items").optJSONArray("item");
	        //log.debug(CC.WOO + " 봉사서비스.ProgramDetailDTO items : "  + items + CC.RESET);
	        if (items == null) {
	            items = new JSONArray();
	            items.put(areaList.getJSONObject("response").getJSONObject("body").getJSONObject("items").getJSONObject("item"));
	        }

	        List<Integer> programNumbers = new ArrayList<>();
	        for (int i = 0; i < items.length(); i++) {
	            programNumbers.add(items.getJSONObject(i).getInt("progrmRegistNo"));
	        }

	        // 2. 각 프로그램 등록 번호에 대해 상세 정보 가져오기
	        for (int progrmRegistNo : programNumbers) {
	            JSONObject detailedInfoJson = getVltrPartcptnItem(progrmRegistNo).getJSONObject("response").getJSONObject("body").getJSONObject("items").getJSONObject("item"); // 이 부분도 XML에서 JSON으로 변환할 필요가 없습니다.

	            ProgramDetailDTO detailDTO = jsonMapper.readValue(detailedInfoJson.toString(), ProgramDetailDTO.class);
	            detailedInfoList.add(detailDTO);
	        }
	    } catch (Exception e) {
	        log.debug(CC.WOO + " 지역정보 API + 상세 정보 API 매핑 중 에러로 catch문 안에 들어왔습니다 " + CC.RESET, e);
	    }

       //log.debug(CC.WOO + " 봉사서비스.ProgramDetailDTO detailedInfoList : "  + detailedInfoList + CC.RESET);
	    return detailedInfoList;
	}




    
}
