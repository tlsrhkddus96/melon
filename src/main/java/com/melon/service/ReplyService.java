package com.melon.service;

import com.melon.domain.Criteria;
import com.melon.domain.ReplyPageDTO;
import com.melon.domain.ReplyVO;

public interface ReplyService {
	
	public int register(ReplyVO vo);
	
	public ReplyVO get(Long rno);
	
	public int modify(ReplyVO vo);
	
	public int remove(Long rno);
	
	public ReplyPageDTO getListPage(Criteria cri, Long bno);
	

}
