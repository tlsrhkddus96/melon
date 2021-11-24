package com.melon.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.melon.domain.BoardVO;
import com.melon.domain.Criteria;

public interface BoardMapper {
	
	//목록
	public List<BoardVO> getList(); 
	
	//페이징이 적용된 목록
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	//등록 (insert만 처리하고 생성된 PK값 알 필요 없는 경우)
	public void insert(BoardVO board);
	
	//등록 (insert처리와 동시에 생성된 PK값 알아야 하는 경우)
	public void insertSelectKey(BoardVO board);
	
	//게시글 상세보기
	public BoardVO read(Long bno);
	
	//삭제
	public int delete(Long bno);
	
	//수정
	public int update(BoardVO board);
	
	//전체 게시물 데이터 개수 확인
	public int getTotalCount(Criteria cri);
	
	//댓글 개수 확인
	public void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
	

}
