package com.fit.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.mapper.UtilityMapper;
import com.fit.service.UtilityService;
import com.fit.vo.Utility;
import com.fit.vo.UtilityFile;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UtilityController {
	@Autowired
	private UtilityService utilityService;
	
	@GetMapping("/addUtility")
	public String utility(Model model,
							@RequestParam(name="utilityNo") int utilityNo) {
		// 디버깅
		log.debug(CC.YOUN+"utilityController.addUtility() utilityNo: "+utilityNo+CC.RESET);
		
		return "/utility/addUtility";
	}
	
	// 해당 URL 경로로 GET 요청이 들어오면 이 메서드가 실행된다.
	@GetMapping("/utilityList")
	public String utilityList(Model model
			, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
			, @RequestParam(name = "utilityCategory", required = false, defaultValue = "") String utilityCategory
			, @RequestParam(name= "utilityNo", required = false, defaultValue = "0") int utilityNo
			) {
		
		// 넘어온값 디버깅
		log.debug(CC.YOUN+"utilityController.utilityList() currentPage: "+currentPage+CC.RESET);
		log.debug(CC.YOUN+"utilityController.utilityList() rowPerPage: "+rowPerPage+CC.RESET);
		log.debug(CC.YOUN+"utilityController.utilityList() utilityCategory: "+utilityCategory+CC.RESET);
	    log.debug(CC.YOUN+"utilityController.utilityList() utilityNo: "+utilityNo+CC.RESET);
		
		// 공용품 리스트 출력
		List<Utility> utilityList = utilityService.getUtilityListByPage(currentPage, rowPerPage, utilityCategory);
		
		int totalCount = utilityService.getUtilityCount(utilityCategory);
		int lastPage = utilityService.getLastPage(totalCount, rowPerPage);
		
		
		// 각 공용품 번호를 통해 공용품 이미지에 넣을 매개값 생성
		Utility utility = utilityService.getUtilityOne(utilityNo);
		
		// 생성된 공용품 매개값을 통해 공용품 파일을 Map 타입으로 조회
		UtilityFile utilityFile = utilityService.getUtilityFileOne(utility);
		
		// 디버깅
		log.debug(CC.YOUN+"utilityController.utilityList() utility: "+utility+CC.RESET);
	    log.debug(CC.YOUN+"utilityController.utilityList() utilityFile: "+utilityFile+CC.RESET);
		
		model.addAttribute("utilityList", utilityList);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("utility", utility);
		model.addAttribute("utilityFile", utilityFile);
		/*
		model.addAttribute("utilityFile", utilityFileMap);
		*/
		
		// 이동할 해당 뷰 페이지를 작성한다.
		return "/utility/utilityList";
	}
}
