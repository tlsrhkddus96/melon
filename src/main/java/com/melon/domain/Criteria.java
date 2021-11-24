package com.melon.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	
	private int pageNum;	//페이지번호
	private int amount;		//한 페이지당 데이터 개수
	
	private String type;	//검색 조건
	private String keyword;	//검색 키워드

	
	public Criteria() {		//기본 값을 1페이지, 10개데이터로 설정
		this(1,10);
	}
	
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	public String[] getTypeArr() {
		return type == null? new String[] {} : type.split("");
	}
}
