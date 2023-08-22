package com.fit.service;

import org.springframework.stereotype.Service;

@Service
public class CommonPagingService {
	
	
	
	// lastPage를 구하는 메서드
	public int getLastPage(int totalCount, int rowPerPage) {
		int lastPage = totalCount / rowPerPage;
		if(totalCount % rowPerPage != 0) {
			lastPage = lastPage + 1;
		}
		/*
		// 디버깅
		log.debug(CC.YOUN+"CommonPagingService.getLastPage() lastPage: "+lastPage+CC.RESET);
		*/
        return lastPage;
    }
	
	// minPage를 구하는 메서드
	public int getMinPage(int currentPage, int pagePerPage) {
		int minPage = (((currentPage - 1) / pagePerPage) * pagePerPage) + 1;
		/*
		// 디버깅
		log.debug(CC.YOUN+"CommonPagingService.getMinPage() minPage: "+minPage+CC.RESET);
		*/
		return minPage;
	}
	
	// maxPage를 구하는 메서드
	public int getMaxPage(int minPage, int pagePerPage, int lastPage) {
		int maxPage = minPage + (pagePerPage - 1);
		
		// 최대 페이지가 마지막페이지를 넘어가지 못하도록 제한
		if (maxPage > lastPage) {
			maxPage = lastPage;
		}
		/*
		// 디버깅
		log.debug(CC.YOUN+"CommonPagingService.getMaxPage() maxPage: "+maxPage+CC.RESET);
		*/
		return maxPage;
	}
}
