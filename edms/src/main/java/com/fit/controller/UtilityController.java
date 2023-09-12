package com.fit.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fit.CC;
import com.fit.service.CommonPagingService;
import com.fit.service.UtilityService;
import com.fit.vo.UtilityDto;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class UtilityController {
	@Autowired
	private UtilityService utilityService;
	
	@Autowired
	private CommonPagingService commonPagingService;
	
	@GetMapping("/utility/addUtility")
	public String addUtility(HttpSession session) {
		// 디버깅
		// log.debug(CC.YOUN+"utilityController.addUtility() utilityNo: "+utilityNo+CC.RESET);
		
		return "/utility/addUtility";
	}
	
	@PostMapping("/utility/addUtility")
	public String addUtility(HttpSession session, UtilityDto utilityDto, HttpServletRequest request) {
		// 1. 웹 어플리케이션의 실제 경로 
		// 2. /image/utility/의 하위 폴더 경로를 추가하여 전체 파일 저장 경로 생성
		// 3. Path는 이미지들을 DB에 저장하고 조회하는데 사용
		String Path = request.getServletContext().getRealPath("/image/utility/");
		
		// 입력유무를 확인
		int row = utilityService.addUtility(utilityDto, Path);
		
		if(row == 1) {
			// 디버깅
			// 공용품 추가시 리스트로
			log.debug(CC.YOUN+"utilityController.addUtility() row: "+row+CC.RESET);
			session.setAttribute("utilityResult", "insert");
			return "redirect:/utility/utilityList";
		} else {
			// 디버깅
			// 공용품 추가 실패시 fail을 매개변수로 view에 전달
			log.debug(CC.YOUN+"utilityController.addUtility() row: "+row+CC.RESET);
			session.setAttribute("utilityResult", "fail");
			return "redirect:/utility/utilityList";
		}
	}
	
	// 해당 URL 경로로 GET 요청이 들어오면 이 메서드가 실행된다.
	@GetMapping("/utility/utilityList")
	public String utilityList(Model model, HttpSession session
			, @RequestParam(name = "currentPage", required = false, defaultValue = "1") int currentPage
			, @RequestParam(name = "rowPerPage", required = false, defaultValue = "5") int rowPerPage
			, @RequestParam(name = "utilityCategory", required = false, defaultValue = "") String utilityCategory
			, @RequestParam(name= "utilityNo", required = false, defaultValue = "0") int utilityNo
			) {
		
		// 넘어온값 디버깅
		log.debug(CC.YOUN+"utilityController.utilityList() currentPage: "+currentPage+CC.RESET);
		log.debug(CC.YOUN+"utilityController.utilityList() rowPerPage: "+rowPerPage+CC.RESET);
		log.debug(CC.YOUN+"utilityController.utilityList() utilityCategory: "+utilityCategory+CC.RESET);
	    log.debug(CC.YOUN+"utilityController.utilityList() utilityNo: "+utilityNo+CC.RESET);
		
		// 각 조건에 따른 전체 행 개수 
		int totalCount = utilityService.getUtilityCount(utilityCategory);
		// 마지막 페이지 계산
		int lastPage = commonPagingService.getLastPage(totalCount, rowPerPage);
		// 페이지네이션에 표기될 쪽 개수
		int pagePerPage = 5;
		// 페이지네이션에서 사용될 가장 작은 페이지 범위
		int minPage = commonPagingService.getMinPage(currentPage, pagePerPage);
		// 페이지네이션에서 사용될 가장 큰 페이지 범위
		int maxPage = commonPagingService.getMaxPage(minPage, pagePerPage, lastPage);
		
		// 공용품 리스트 출력 -> join 통해 파일경로와 파일저장이름을 가지고 있음 
		List<UtilityDto> utilityList = utilityService.getUtilityListByPage(currentPage, rowPerPage,  utilityCategory);
		
		// 디버깅
	    // log.debug(CC.YOUN+"utilityController.utilityList() utilityFile: "+utilityFile+CC.RESET);
	    log.debug(CC.YOUN+"utilityController.utilityList() utilityList: "+utilityList+CC.RESET);
		
	    // 페이징에 필요한 값 모델로 view에 넘김
		model.addAttribute("utilityList", utilityList);
		model.addAttribute("currentPage", currentPage);
		model.addAttribute("lastPage", lastPage);
		model.addAttribute("pagePerPage", pagePerPage);
		model.addAttribute("minPage", minPage);
		model.addAttribute("maxPage", maxPage);
		
		// 이동할 해당 뷰 페이지를 작성한다.
		return "/utility/utilityList";
	}
	
	// view로부터 체크된 항목에 대한 값을 매개값으로 해당 항목에 해당하는 공용품 게시글을 삭제, 삭제 유무의 결과를 세션을 통해 전달하여 view에서 경고창 출력
	@PostMapping("/utility/delete")
    public String deleteSelectedUtilities(HttpSession session
    		,	// 선택된 체크박스의 공용품 번호를 리스트 형식으로 매개값을 받는다.
    			@RequestParam(value = "selectedItems", required = false) List<Long> selectedItems) {
		
		// 삭제 유무를 확인
		int row = 0;
		
		// 체크박스를 선택한 값이 있다면
        if (selectedItems != null && !selectedItems.isEmpty()) {
        	// 체크된 매개값을 해당하는 공용품 번호에 매칭하여 삭제하는 메서드 동작
            for (Long utilityNo : selectedItems) {
            	// 서비스단의 공용품글과 파일을 동시에 삭제하는 메서드 실행
                row = utilityService.removeUtilityAndFile(utilityNo);
            }
        }
        
        if(row >= 1) {
			// 디버깅
			// 공용품 삭제시 데이터를 보낸다
			log.debug(CC.YOUN+"utilityController.deleteSelectedUtilities() row: "+row+CC.RESET);
			session.setAttribute("utilityResult", "delete");
			return "redirect:/utility/utilityList";
		} else {
			// 디버깅
			// 공용품 추가 실패시 fail을 매개변수로 view에 전달
			log.debug(CC.YOUN+"utilityController.deleteSelectedUtilities() row: "+row+CC.RESET);
			session.setAttribute("utilityResult", "fail");
			return "redirect:/utility/utilityList";
		}
    }
	
	@GetMapping("/utility/modifyUtility")
	public String modifyUtility(Model model, HttpSession session,
			// 공용품 리스트에서 수정 버튼을 클릭시 수정 폼으로 utility 객체를 보내준다
			@RequestParam(name = "utilityNo", required = false, defaultValue = "0") int utilityNo) {
		
		// 디버깅
		log.debug(CC.YOUN+"utilityController.modifyUtility() utilityNo: "+utilityNo+CC.RESET);
		
		// 공용품 번호를 통해 공용품 리스트를 불러온다.
		UtilityDto utilityDto = utilityService.getUtilityOne(utilityNo);
		
		// 모델에 값 저장 후 수정 폼에서 사용
		model.addAttribute("utilityDto", utilityDto);
		
		return "/utility/modifyUtility";
	}
	
	@PostMapping("/utility/modifyUtility")
	// 수정폼으로부터 utilityNo를 name 속성을 통해 hidden으로 전달받고 이값을 int utilityNo 요청파라미터값으로 전달받는다.
	public String modifyUtility(HttpSession session, UtilityDto utilityDto, HttpServletRequest request,
			@RequestParam(name = "utilityNo", required = false, defaultValue = "0") int utilityNo) {
		
		// 입력받은 값 디버깅
		log.debug(CC.YOUN+"utilityController.modifyUtility() utilityNo: "+utilityNo+CC.RESET);
		
		String Path = request.getServletContext().getRealPath("/image/utility/");
		
		// 기존 파일 삭제를 위해 공용품 정보를 조회 -> 해당 공용품 번호의 공용품 내역이 있다면
		UtilityDto existingUtility = utilityService.getUtilityOne(utilityNo);
		
		int row = utilityService.modifyUtility(utilityDto, Path, existingUtility);
		
		if(row == 1) {
			// 디버깅
			// 공용품 수정 성공시 리스트로
			log.debug(CC.YOUN+"utilityController.modifyUtility() row: "+row+CC.RESET);
			session.setAttribute("utilityResult", "update");
			return "redirect:/utility/utilityList";
		} else {
			// 디버깅
			// 공용품 수정 실패시 fail을 매개변수로 view에 전달
			log.debug(CC.YOUN+"utilityController.modifyUtility() row: "+row+CC.RESET);
			session.setAttribute("utilityResult", "fail");
			return "redirect:/utility/utilityList";
		}
	}
	
}
