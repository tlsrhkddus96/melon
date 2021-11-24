package com.melon.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.melon.domain.BoardAttachVO;
import com.melon.domain.BoardVO;
import com.melon.domain.Criteria;
import com.melon.domain.PageDTO;
import com.melon.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/")		// '/board'로 시작하는 모든 처리를 BoardController가 하도록 지정
@AllArgsConstructor				//BoardController는 BoardService에 의존적이므로 @AllArgs.. 를 통해 생성자생성 및 주입
public class BoardController {
	
	private BoardService service;
	
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {	//Model을 파라미터로 지정해 'list'에 결과를 담아 전달(addAttribute)
		
		log.info("list" + cri);
		model.addAttribute("list", service.getList(cri));
		
		int total = service.getTotal(cri);
		
		//페이징을 위해 Model에 pageMaker라는 이름으로 pageDTO를 심기
		model.addAttribute("pageMaker", new PageDTO(cri,total));
		
	}
	
	@GetMapping("/register")	//등록작업은 POST에서 하지만, 화면에서 입력받아야하므로 별도의 처리가 없는 Get방식url생성
	@PreAuthorize("isAuthenticated()")	//로그인 한 사용자만 등록작업 할 수 있게 설정
	public void register() {
		
	}
	
	@PostMapping("/register")			//RedirectAttributes를 이용해 등록작업이 끝나면 목록화면으로 이동
	@PreAuthorize("isAuthenticated()")	//로그인 한 사용자만 등록작업 할 수 있게 설정
	public String register(BoardVO board, RedirectAttributes rttr ) {
		
		log.info("register : " + board);
		
		if (board.getAttachList() != null) {
			
			board.getAttachList().forEach(attach -> log.info(attach));
		}
		
		service.register(board);
		rttr.addFlashAttribute("result", board.getBno());	// 'result'에 bno 함께 전달
		return "redirect:/board/list";	//'redirect:'를 써서 response.sendRedirect() 처리 
		
	}
	
	
	@GetMapping({"/get","/modify"})		//수정이나 조회페이지로 가려면 GET방식으로 접근하고, 작업은 POST방식으로 사용한다.
	public void get(Long bno, @ModelAttribute("cri")Criteria cri, Model model) {
		
		log.info("/get or modify" + bno);
		//게시물의 bno값과 수정이나 조회를 하려면 내용이 있어야하므로 model에 각 내용을 심어주고 전달
		model.addAttribute("board", service.get(bno));
		
	}
	
	
	@PreAuthorize("principal.username == #board.writer")	//로그인한 사용자와 파라미터로 전달되는 작성자가 일치하는지 체크
	@PostMapping("/modify")				//수정 작업후 목록으로 가기위해 RedirectAttributes 사용	
	public String modify(BoardVO board,Criteria cri, RedirectAttributes rttr) {
		
		log.info("modify : " + board);
		
		if(service.modify(board)) {	//수정 여부를 boolean으로 처리하기때문에 성공한경우에만 RedirectAttributes에 추가
			rttr.addFlashAttribute("result", "성공");
		}
		
		//수정 작업 후 목록으로 갈 때 페이지 값과 검색필터 함께 전달
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
		
	}
	
	@PreAuthorize("principal.username == #writer")	//로그인한 사용자와 현재 파라미터로 전달되는 작성자가 일치하는지 체크
	@PostMapping("/remove")				//삭제 작업후 목록으로 가기위해 RedirectAttributes 사용	
	public String remove(Long bno, Criteria cri, RedirectAttributes rttr, String writer) {
		
		log.info("remove : " + bno);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {	//삭제 작업 또한 boolean으로 처리, 성공한 경우에만 RedirectAttributes에 추가
			
			// 첨부파일 삭제
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result","성공");
		}
		
		//삭제 작업 후 목록으로 갈 때 페이지 값과 검색필터 함께 전달
		rttr.addAttribute("pageNum",cri.getPageNum());
		rttr.addAttribute("amount",cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/list";
	}
	
	@GetMapping(value = "/getAttachList",
			produces = MediaType.APPLICATION_JSON_UTF8_VALUE)	//게시물 번호를 이용해 첨부파일 관련 데이터를 JSON으로 반환
	@ResponseBody												//@RestController가 아니므로 직접 @ResponseBody태그 사용
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
		
		log.info("getAttachList" + bno);
		
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
	}
	
	
	//첨부파일 삭제 메소드 
	private void deleteFiles(List<BoardAttachVO> attachList) {
		
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("delete attach files.... ");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			
			try {
				Path file = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				
				Files.deleteIfExists(file);
				
				if(Files.probeContentType(file).startsWith("image")) {
					
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					
					Files.delete(thumbNail);
				}
				
			}catch(Exception e){
				log.error("delete file error" + e.getMessage());
			}
		});
		
	}
	

}
