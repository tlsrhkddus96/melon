package com.melon.service;

import java.util.List;

import com.melon.domain.BoardAttachVO;
import com.melon.domain.BoardVO;
import com.melon.domain.Criteria;

public interface BoardService {

	//목록
	public List<BoardVO> getList(Criteria cri);
	
	//등록
	public void register(BoardVO board);
	
	//게시글 상세보기
	public BoardVO get(Long bno);
	
	//수정
	public boolean modify(BoardVO board);
	
	//삭제
	public boolean remove(Long bno);
	
	//전체 데이터 개수 구하기
	public int getTotal(Criteria cri);
	
	//첨부파일 목록 가져오기
	public List<BoardAttachVO> getAttachList(Long bno);
	
}
