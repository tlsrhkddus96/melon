package com.melon.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.melon.domain.Criteria;
import com.melon.domain.ReplyPageDTO;
import com.melon.domain.ReplyVO;
import com.melon.mapper.BoardMapper;
import com.melon.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService{

	@Setter(onMethod_ =  @Autowired)
	private ReplyMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper boardMapper;
	

	@Transactional	// 등록작업과 삭제작업에서는 BoardMapper와 ReplyMapper가 같이 처리
	@Override
	public int register(ReplyVO vo) {
		log.info("register....."+ vo);
		
		boardMapper.updateReplyCnt(vo.getBno(), 1); //등록 작업시 ReplyCnt +1
		return mapper.insert(vo);
	}

	@Override
	public ReplyVO get(Long rno) {
		log.info("get....."+ rno);
		return mapper.read(rno);
		
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("modify......" + vo);
		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(Long rno) {
		log.info("remove....."+ rno);
		
		ReplyVO vo = mapper.read(rno);
		
		boardMapper.updateReplyCnt(vo.getBno(), -1); //삭제 작업시 replyCnt - 1
		return mapper.delete(rno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		log.info("get Reply List of a Board " + bno);
		
		return new ReplyPageDTO(
				mapper.getCountByBno(bno),
				mapper.getListWithPaging(cri, bno));
	}

}
