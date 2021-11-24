package com.melon.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.melon.domain.Criteria;
import com.melon.domain.ReplyPageDTO;
import com.melon.domain.ReplyVO;
import com.melon.service.ReplyService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies/")	// /replies/로 시작하는 모든 요청을 ReplyController가 담당
@RestController					// RestController 어노테이션을 사용해 ViewResolver 적용X
@Log4j
@AllArgsConstructor				// ReplyService타입의 객체인 ReplyServiceImpl 객체를 주입받도록 설정
public class ReplyController {

	private ReplyService service;
	
	//댓글등록
	@PreAuthorize("isAuthenticated()") // 댓글등록이 로그인한 사용자인지 확인
	@PostMapping(value = "/new",	//POST방식으로만 동작
				consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE}) //consumes와 produces로 JSON방식의 데이터만 처리
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){ //RequestBody를 이용해 json 데이터를 ReplyVO 타입으로 변환
		
		log.info("ReplyVO : " + vo);
		
		int insertCount = service.register(vo);
		
		log.info("Reply INSERT COUNT : " + insertCount);
		
		//삼항연산을 사용, 댓글이 추가된 숫자를 확인해서 브라우저에 200OK 또는 500 서버에러를 발생시킴
		return insertCount == 1 
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		
	}
	
	//댓글목록
	@GetMapping(value = "/pages/{bno}/{page}",	//PathVariable을 이용해 URL 경로의 일부를 파라미터로 사용
			produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("page") int page, @PathVariable("bno")Long bno){ 
		
		Criteria cri = new Criteria(page,10);
		
		log.info("get Reply List bno :" + bno);
		log.info(cri);
		
		return new ResponseEntity<>(service.getListPage(cri, bno), HttpStatus.OK);
	}
	
	//댓글조회
	@GetMapping(value="/{rno}",
			produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		log.info("get: " + rno);
		
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}
	
	
	//댓글삭제
	@PreAuthorize("principal.username == #vo.replyer")
	@DeleteMapping(value = "/{rno}")
	public ResponseEntity<String> remove(@RequestBody ReplyVO vo , @PathVariable("rno") Long rno){
		
		log.info("remove" + rno);
		
		log.info("replyer: " + vo.getReplyer());
		
		return service.remove(rno) == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//댓글수정
	@PreAuthorize("principal.username == #vo.replyer")
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH}, value="/{rno}",
			consumes = "application/json")
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo, @PathVariable("rno")Long rno){
		vo.setRno(rno);
		
		log.info("rno: " + rno);
		
		log.info("modify " + vo);
		
		return service.modify(vo) == 1
				? new ResponseEntity<>("success",HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	
}
