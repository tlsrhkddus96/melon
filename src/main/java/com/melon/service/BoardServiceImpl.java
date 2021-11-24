package com.melon.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.melon.domain.BoardAttachVO;
import com.melon.domain.BoardVO;
import com.melon.domain.Criteria;
import com.melon.mapper.BoardAttachMapper;
import com.melon.mapper.BoardMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service //비즈니스 영역 담당 객체 표시를 위해 @service어노테이션 삽입
public class BoardServiceImpl implements BoardService{
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Override
	public List<BoardVO> getList(Criteria cri) {

		log.info("목록 + 페이징..... ");
		return mapper.getListWithPaging(cri);
		
	}

	@Transactional
	@Override
	public void register(BoardVO board) {
		
		log.info("등록 ..... "  + board);
		mapper.insertSelectKey(board);
		
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach ->{
			
			attach.setBno(board.getBno());
			attachMapper.insert(attach);
		});
		
	}

	@Override
	public BoardVO get(Long bno) {
		
		log.info("상세보기 ..... " + bno);
		return mapper.read(bno);
		
	}

	
	//첨부파일의 경우 기존 데이터를 전부 삭제하고 넘어온 데이터를 다시 추가한다.
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		
		log.info("수정....." + board);
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0 ) {
			
			board.getAttachList().forEach(attach -> {
				
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		
		log.info("삭제....." + bno);
		
		attachMapper.deleteAll(bno);
		
		return mapper.delete(bno) == 1;
	}

	@Override
	public int getTotal(Criteria cri) {
		
		log.info("get total Count");
		return mapper.getTotalCount(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		
		log.info("Get Attach list by bno" + bno);
		
		return attachMapper.findByBno(bno);
	}

}
