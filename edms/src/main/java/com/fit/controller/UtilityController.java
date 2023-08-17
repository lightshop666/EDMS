package com.fit.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
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
	
	@GetMapping("/utility/addUtility")
	public String addUtility(Model model, HttpSession session) {
		// 디버깅
		// log.debug(CC.YOUN+"utilityController.addUtility() utilityNo: "+utilityNo+CC.RESET);
		
		return "/utility/addUtility";
	}
	
	@PostMapping("/utility/addUtility")
	public String addUtility(HttpSession session, Utility utility, HttpServletRequest request) {
		// 경로 입력 후 /image/utility/값만 추출하여 DB에 저장 -> 리스트로 조회하기 위함
		String Path = request.getServletContext().getRealPath("/image/utility/");
		
		// 입력유무를 확인
		int row = utilityService.addUtility(utility, Path);
		
		if(row == 1) {
			// 디버깅
			// 공용품 추가시 리스트로
			log.debug(CC.YOUN+"utilityController.addUtility() row: "+row+CC.RESET);
			return "redirect:/utility/utilityList";
		} else {
			// 디버깅
			// 공용품 추가 실패시 fail을 매개변수로 view에 전달
			log.debug(CC.YOUN+"utilityController.addUtility() row: "+row+CC.RESET);
			return "redirect:/utility/utilityList?result=fail";
		}
	}
	
	
	// 해당 URL 경로로 GET 요청이 들어오면 이 메서드가 실행된다.
	@GetMapping("/utility/utilityList")
	public String utilityList(Model model, HttpSession session
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
		
		// 공용품 리스트 출력 -> join 통해 파일경로와 파일저장이름을 가지고 있음 
		List<Utility> utilityList = utilityService.getUtilityListByPage(currentPage, rowPerPage, utilityCategory);
		
		int totalCount = utilityService.getUtilityCount(utilityCategory);
		int lastPage = utilityService.getLastPage(totalCount, rowPerPage);
		
		// 디버깅
	    // log.debug(CC.YOUN+"utilityController.utilityList() utilityFile: "+utilityFile+CC.RESET);
	    log.debug(CC.YOUN+"utilityController.utilityList() utilityList: "+utilityList+CC.RESET);
		
		model.addAttribute("utilityList", utilityList);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("lastPage", lastPage);
		
		// 이동할 해당 뷰 페이지를 작성한다.
		return "/utility/utilityList";
	}
}
