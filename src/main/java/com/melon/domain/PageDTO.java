package com.melon.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

	private int startPage;	//현재 보고있는 페이지 기준 첫번째로 보일 페이지
	private int endPage;	//현재 보고있는 페이지 기준 마지막으로 보일 페이지
	private boolean prev, next;	//이전, 다음 버튼 활성화 여부
	
	private int total;		//전체 데이터 개수
	private Criteria cri;
	
	public PageDTO(Criteria cri, int total) {
		this.cri = cri;
		this.total = total;
		
		//Math의 올림기능을 이용해 현재 보고있는 페이지 기준 마지막 페이지 구하기
		this.endPage = (int)(Math.ceil(cri.getPageNum()/10.0) ) * 10;
		
		this.startPage = this.endPage-9;
		
		//총 데이터 개수를 고려해 마지막페이지 구하기
		int realEnd = (int)(Math.ceil( (total*1.0) /cri.getAmount() ) );
		
		if (realEnd < this.endPage) {
			this.endPage = realEnd;
		}
		
		this.prev = this.startPage > 1;
		this.next = this.endPage < realEnd;
	}
}
