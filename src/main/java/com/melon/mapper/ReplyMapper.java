package com.melon.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.melon.domain.Criteria;
import com.melon.domain.ReplyVO;

public interface ReplyMapper {
	
	//등록
	public int insert(ReplyVO vo);
	
	//조회
	public ReplyVO read(Long bno);

	//삭제
	public int delete(Long rno);
	
	//업데이트
	public int update(ReplyVO reply);
	
	//리스트
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("bno") Long bno);
	
	//댓글 숫자파악
	public int getCountByBno(Long bno);
	
	
	
}
