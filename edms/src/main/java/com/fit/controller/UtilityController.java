package com.fit.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.mapper.UtilityMapper;
import com.fit.service.UtilityService;
import com.fit.vo.Utility;

import lombok.extern.slf4j.Slf4j;

/*
	 ANSI_RESET = "\u001B[0m";
	 ANSI_LightRED = "\u001B[91m";
*/

@Slf4j
@Controller
public class UtilityController {
	@Autowired
	private UtilityService utilityService;
	
	@GetMapping("/addUtility")
	public String utility(Model model,
							@RequestParam(name="utilityNo") int utilityNo) {
		// 디버깅
		log.debug("\u001B[101m"+"utilityController.addUtility() utilityNo: "+utilityNo+"\u001B[0m");
		
		return "/utility/addUtility";
	}
	
	// 해당 URL 경로로 GET 요청이 들어오면 이 메서드가 실행된다.
	@GetMapping("/utilityList")
	public String utilityList(Model model
			, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			, @RequestParam(name = "rowPerPage", required = false, defaultValue = "10") int rowPerPage
			, @RequestParam(name = "utilityCategory", required = false, defaultValue = "") String utilityCategory) {
		
		// 넘어온값 디버깅
		log.debug("\u001B[101m"+"utilityController.utilityList() currentPage: "+currentPage+"\u001B[0m");
		log.debug("\u001B[101m"+"utilityController.utilityList() rowPerPage: "+rowPerPage+"\u001B[0m");
		log.debug("\u001B[101m"+"utilityController.utilityList() utilityCategory: "+utilityCategory+"\u001B[0m");
		
		List<Utility> utilityList = utilityService.getUtilityListByPage(currentPage, rowPerPage, utilityCategory);
		
		int totalCount = utilityService.getUtilityCount(utilityCategory);
		int lastPage = utilityService.getLastPage(totalCount, rowPerPage);
		
		model.addAttribute("utilityList", utilityList);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("lastPage", lastPage);
		
		// 이동할 해당 뷰 페이지를 작성한다.
		return "/utility/utilityList";
	}
}