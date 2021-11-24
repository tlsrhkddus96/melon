<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp" %>



<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 상세보기</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">게시글 상세보기</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
			
				<!-- 모든 데이터를 readonly로 바꾸어 수정불가능하게 작성 -->
				<div class="form-group">
					<label>게시물 번호</label> <input class="form-control" name="bno"
					value='<c:out value="${board.bno }"/>' readonly="readonly">
				</div>
		
				<div class="form-group">
					<label>제목</label> <input class="form-control" name="title"
					value='<c:out value="${board.title }"/>' readonly="readonly">
				</div>
		
				<div class="form-group">
					<label>내용</label>
					 <textarea class="form-control" rows="7" name="content"
					readonly="readonly"><c:out value="${board.content }"/></textarea>
				</div>
		
				<div class="form-group">
					<label>작성자</label> <input class="form-control" name="writer"
					value='<c:out value="${board.writer }"/>' readonly="readonly">
				</div>
				
				<sec:authentication property="principal" var="pinfo" />
				
				<!-- 작성자와 로그인한 유저ID가 동일해야 수정/삭제 버튼이 보임 -->
					<sec:authorize access="isAuthenticated()">
						<c:if test="${pinfo.username ne board.writer}">
							<button data-oper="modify" class="btn btn-default">수정/삭제</button>
						</c:if>
					</sec:authorize>
							
				<button data-oper="list" class="btn btn-info">목록</button>
				
				<form id="operForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno }"/>'>
					<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }"/>'>
					<input type="hidden" name="amount" value='<c:out value="${cri.amount }"/>'>
					<input type="hidden" name="keyword" value='<c:out value="${cri.keyword }"/>'>
					<input type="hidden" name="type" value='<c:out value="${cri.type }"/>'>
				</form>
			
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- ./panel body -->
	</div>
	<!-- ./panel -->
</div>
<!-- ./row  -->


<!-- 첨부파일 div -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">첨부파일</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
			
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
			
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<div class="bigPictureWrapper">
	<div class="bigPicture">
	</div>
</div>


<!-- 댓글 div -->
<div class="row">
	<div class="col-lg-12">
	
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i> 댓글
				<sec:authorize access="isAuthenticated()">
					<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">새 댓글</button>
				</sec:authorize>
			</div>
			
			<div class="panel-body">
				<ul class="chat">
				</ul>
			</div>
		
			<div class="panel-footer">
			
			</div>
		
		
		</div>
	</div>
</div>
			
			<!-- 댓글 Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="ture">&times;</button>
					<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
				</div>
				<div class="modal-body">
					<div class="form-group">
						<label>내용</label>
						<input class="form-control" name="reply" value="New Reply!">
					</div>
					<div class="form-group">
						<label>작성자</label>
						<input class="form-control" name="replyer" value="replyer">
					</div>
					<div class="form-group">
						<label>작성일</label>
						<input class="form-control" name="replyDate" value="">
					</div>
				</div>
				<div class="modal-footer">
					<button id="modalModBtn" type="button" class="btn btn-warning">수정</button>
					<button id="modalRemoveBtn" type="button" class="btn btn-danger">삭제</button>
					<button id="modalRegisterBtn" type="button" class="btn btn-default">등록</button>
					<button id="modalCloseBtn" type="button" class="btn btn-default">닫기</button>
				</div>
				
			</div>
		</div>
	</div>


<script type="text/javascript" src="/resources/js/reply.js"></script>

<script type="text/javascript">

	$(document).ready(function(){
		
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		
			showList(1);
			
			function showList(page){
				
				replyService.getList({bno:bnoValue, page: page|| 1} ,
					function(replyCnt, list){
					
					
					if(page == -1){
						pageNum = Math.ceil(replyCnt/10.0);
						showList(pageNum);
						return;
					}
					
					if(list == null || list.length == 0){
						return;
					}

					var str="";
					
					for (var i =0, len= list.length || 0;  i< len; i++){
						str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
						str +=" <div><div class='header'><strong class='primary-font'>["+list[i].rno+"] "+list[i].replyer+"</strong>";
						str +="		<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
						str +="		<p>"+list[i].reply+"</p></div></li>";	
					}
					
				replyUL.html(str);
				showReplyPage(replyCnt);	//panel-footer 댓글페이지
					
				}); //end function
			}//end showList
			
		/* 댓글Modal */
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		var modalCloseBtn =$("#modalCloseBtn");
		
		var replyer = null;
		
		<sec:authorize access="isAuthenticated()">
		
		replyer = '<sec:authentication property="principal.username"/>';
		
		</sec:authorize>
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		
		
		//새 댓글 버튼 클릭시 이벤트
		$("#addReplyBtn").on("click", function(e){
			
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer).attr("readonly","readonly");
			modalInputReplyDate.closest("div").hide();	//등록일은 보이지 않게 div hide처리
			modal.find("button[id != 'modalCloseBtn']").hide();	//닫기 버튼을 제외한 버튼 hide처리
			
			modalRegisterBtn.show();	//등록버튼 다시 보여주기
			
			$(".modal").modal("show");
		});
		
		// 댓글 클릭시 조회 이벤트
		$(".chat").on("click","li",function(e){
			
			var rno = $(this).data("rno");
			
			replyService.get(rno, function(reply){
				
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate))
				.attr("readonly","readonly");
				modal.data("rno",reply.rno);
				
				modal.find("button[id !='modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
			});
		});
		
		
		/* //CSRF 토큰 전송
		$(document).ajaxSend(function(e, xhr, options){
			
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		}); */
		
		//댓글 등록버튼
		modalRegisterBtn.on("click",function(e){
			
			var reply = {
					reply : modalInputReply.val(),
					replyer : modalInputReplyer.val(),
					bno : bnoValue
				};
			
			replyService.add(reply, function(result){
				
				alert(result);
				
				modal.find("input").val("");
				modal.modal("hide");
				
				showList(-1); //새 댓글을 추가하면 전체 댓글 숫자 파악
				
			});
			
		});
		
		//댓글 수정버튼
		modalModBtn.on("click",function(e){
			
			var originalReplyer = modalInputReplyer.val();
			
			var reply = {
					rno:modal.data("rno"),
					reply : modalInputReply.val(),
					replyer : originalReplyer};
			
			if(!replyer){
				alert("로그인 후 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			console.log("OriginalReplyer : " + originalReplyer);
			
			if(replyer != originalReplyer){
				alert("자신이 작성한 댓글만 수정이 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result){
				
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		//댓글 삭제버튼
		modalRemoveBtn.on("click",function(e){
			
			var rno = modal.data("rno");
			
			console.log("RNO" + rno);
			console.log("Replyer" + replyer);
			
			if(!replyer){
				
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			
			console.log("Original Replyer: " + originalReplyer);
			
			if(replyer != originalReplyer){
				
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.remove(rno, originalReplyer, function(result){
				
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		//댓글 닫기버튼
		modalCloseBtn.on("click",function(e){
			
			modal.modal("hide");
		})
		
		
		/* panel-footer에 댓글 페이지 번호 출력 */
		var pageNum = 1;
		var replyPageFooter = $(".panel-footer");
		
		function showReplyPage(replyCnt){
			
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum -9;
			
			var prev = startNum != 1;
			var next = false;
			
			if(endNum * 10 >= replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}
			
			if(endNum * 10 < replyCnt){
				next = true;
			}
			
			var str = "<ul class='pagination pull-right'>";
			
			if(prev){
				str+= "<li class='paginate_button previous'><a class='page-link' href='"+(startNum -1)+"'>이전</a></li>";
			}
			
			for(var i = startNum ; i<= endNum; i++){
				var active = pageNum == i? "active":"";
				
				str+= "<li class='paginate_button "+ active +" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
			
			if(next){
				str+= "<li class='paginate_button next'><a class='page-link' href='"+(endNum + 1)+"'>다음</a></li>";
			}
			
			str+= "</ul></div>";
			
			replyPageFooter.html(str);
			
		}
		
		/*페이지 번호 클릭했을 때 새로운 댓글을 가져오도록 하는 이벤트 */
		replyPageFooter.on("click","li a", function(e){
			
			e.preventDefault();
			
			var targetPageNum = $(this).attr("href");
			
			pageNum = targetPageNum;
			
			showList(pageNum);
			
		})
		
		
	});
	
	
	
	
	
	


</script>

<script type="text/javascript">

	$(document).ready(function(){
		
		var operForm = $("#operForm");
		
		/* 수정 버튼을 누르면 bno와 함께 페이지값과 검색필터를 같이 전달해주고 <form>태그를 submit 시킨다. */
		$("button[data-oper='modify']").on("click", function(e){
		
			operForm.attr("action","/board/modify").submit();
		});

		/* 목록 버튼을 누르면 bno값이 필요없으므로 지우고, 페이지값과 검색필터만 파라미터로 넘겨준다. */
		$("button[data-oper='list']").on("click", function(e){
			
			operForm.find("#bno").remove();
			operForm.attr("action","/board/list").submit();
		});
		
		
		
	});

</script>


<!-- 첨부파일 이벤트  -->
<script>

	$(document).ready(function(){
		
		(function(){
			
			var bno = '<c:out value="${board.bno}"/>';
			
			$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
				
				console.log(arr);
				
				var str="";
				
				$(arr).each(function(i, attach){
					
					//이미지 여부에 따라 li태그 변경
					if(attach.fileType){
						
						var fileCallPath = encodeURIComponent(
								attach.uploadPath+ "/s_" + attach.uuid + "_" + attach.fileName);
						
						str+= "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-fileName='"+attach.fileName+"'"+
							"data-type='"+attach.fileType+"'><div>";
						str+= "<img src='/display?fileName="+fileCallPath+"'>";
						str+= "</div>";
						str+= "</li>";
					
					} else {
						
						str+= "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-fileName='"+attach.fileName+"'"+
						"data-type='"+attach.fileType+"'><div>";
						str+= "<span>"+attach.fileName+"</span><br>";
						str+= "<img src='/resources/img/attach.png'>";
						str+= "</div>";
						str+= "</li>";
					}
				});
				
				$(".uploadResult ul").html(str);
				
			});//end getjson
		
		})();//end function
		
		
		/* 첨부파일 클릭 시 이벤트 */
		$(".uploadResult").on("click","li", function(e){
			
			console.log("view image");
			
			var liObj = $(this);
			
			var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));
			
			if(liObj.data("type")){
				
				//이미지타입이 True이면 showImage()호출
				showImage(path.replace(new RegExp(/\\/g),"/")); // '\\' > '/'로 변경해서 호출
			
			}else{
				
				//일반 파일이면 다운로드
				self.location ="/download?fileName=" + path
						
			}
			
			
		});
		
		
		/* 이미지클릭시 css */
		function showImage(fileCallPath){
			
			alert(fileCallPath);
			
			$(".bigPictureWrapper").css("display","flex").show();
			
			$(".bigPicture")
			.html("<img src='/display?fileName="+fileCallPath+"'>")
			.animate({width:"100%", height:"100%"}, 500 );
			
		}
		
		
		$(".bigPictureWrapper").on("click", function(e){
			
			$(".bigPicture").animate({width : "0%", height: "0%"}, 500);
			setTimeout(function(){
				$(".bigPictureWrapper").hide();
			},500);
		});
		
	});

</script>





<%@include file="../includes/footer.jsp" %>