<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>


            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">게시글 리스트</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            
            
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">게시글 리스트
                        <button id="regBtn" type="button" class="btn btn-xs pull-right" >게시물 등록</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th width="150px">게시물 번호</th>
                                            <th width="500px">제목</th>
                                            <th>작성자</th>
                                            <th>작성일</th>
                                            <th>수정일</th>
                                        </tr>
                                    </thead>
                                    
                             <!-- BoardController의 '/board/list'를 실행했을 때 Model이용해 게시물 목록을 'list'라는 이름으로 전달했음 -->	
                                   	<c:forEach items="${list}" var="board">
										<tr>
											<td><c:out value="${board.bno}" /></td>
											<td><a class="move" href='<c:out value="${board.bno}" />'>
												<c:out value="${board.title}"/> 
												<b>[ <c:out value="${board.replyCnt }"/> ]</b>
												</a></td>
											<td><c:out value="${board.writer}" /></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></td>
											<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate}"/></td>
										</tr>                                   		
                                   	</c:forEach> 
                                </table>
                                
                             <div class="row">
                            	<div class="col-lg-12">
                            	
                            		<form id="searchForm" action="/board/list" method="get">
                            			<select name="type">
                            				<option value=""<c:out value="${pageMaker.cri.type == null? 'selected':'' }"/>>--</option>
                            					<option value="T"
                            						<c:out value="${pageMaker.cri.type eq 'T' ?'selected':'' }"/>>제목</option>
                            					<option value="C"
                            						<c:out value="${pageMaker.cri.type eq 'C' ?'selected':'' }"/>>내용</option>
                            					<option value="W"
                            						<c:out value="${pageMaker.cri.type eq 'W' ?'selected':'' }"/>>작성자</option>
                            					<option value="TC"
                            						<c:out value="${pageMaker.cri.type eq 'TC' ?'selected':'' }"/>>제목 or 내용</option>
                            					<option value="TW"
                            						<c:out value="${pageMaker.cri.type eq 'TW' ?'selected':'' }"/>>제목 or 작성자</option>
                            					<option value="TWC"
                            						<c:out value="${pageMaker.cri.type eq 'TWC' ?'selected':'' }"/>>제목 or 작성자 or 내용</option>
                            			</select>
                            			<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword }"/>'/>
                            			<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum }"/>'/>
                            			<input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount }"/>'/>
                            			<button class="btn btn-default">검색</button>
                            		</form>
                            	
                            	</div>
                            </div>
                                
                            <div class="pull-right">
                            	<ul class="pagination">
                            	
                            		<!-- BoardController에서  -->
                            		<c:if test="${pageMaker.prev }">
                            			<li class="paginate_button previous">
                            			<a href="${pageMaker.startPage -1 }">이전</a></li>
                            		</c:if>
                            		
                            		<c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
                            			<li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active':'' }">
                            			<a href="${num }">${num }</a></li>
                            		</c:forEach>
                            		
                            		<c:if test="${pageMaker.next }">
                            			<li class="paginate_button next">
                            			<a href="${pageMaker.endPage +1 }">다음</a></li>
                            		</c:if>
                            	</ul>
                            </div>
                            
                            <form id="actionForm" action="/board/list" method="get">
                            	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
                            	<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
                            	<input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type }"/>'>
                            	<input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword }"/>'>
                            </form>	
                                
                                
                           	<!-- Modal 추가 -->
                            <div class="modal fade" id ="myModal" tabindex="-1" role="dialog"
                            	aria-labelledby="myModalLabel" aria-hidden="true">
                            	<div class="modal-dialog">
                            		<div class="modal-content">
                            			<div class="modal-header">
                            				<button type="button" class="close" data-dismiss="modal"
                            					aria-hidden="true">&times;</button>
                            				<h4 class="modal-title" id="myModalLabel">Modal title</h4>
                            			</div>
                            			<div class="modal-body">처리가 완료되었습니다.</div>
                            			<div class="modal-footer">
                            				<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                            			</div>
                            		</div>
                            		<!-- /.modal-content -->
                            	</div>
                            	<!-- /.modal-dialog -->	
                            </div>
							<!-- /.modal --> 
							
							   
                            </div>
                            <!-- /.table-responsive -->
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
             </div>
             <!-- /.row -->
             
 
 
 <script type="text/javascript">
 	
 $(document).ready(function(){
	/* 등록, 삭제, 수정메소드의  RedirectAttributes rttr에 bno값을 result변수에 넣어두었다.
		해당 작업들이 완료되면 board/list로 이동하고, 화면에 완료된 작업의 게시물 번호를 띄워준다.*/
	 var result='<c:out value="${result}"/>';
	 
	 checkModal(result);
	 
	 function checkModal(result){
		 
		 /* result에 값이 없으면 모달X */
		 if(result === ""){
			 return;
		 }
		 
		 /* 등록메소드 result의 값이 있으면 modal-body class 값 변경  */
		 if(parseInt(result) > 0 ){
			 $(".modal-body").html("게시글 " + parseInt(result) + "번이 등록되었습니다.");
		 }
		 
		 $("#myModal").modal("show");
	 }
	 
	 /* regBtn ID 클릭시 register페이지 이동 */
	 $("#regBtn").on("click",function(){
		
		 location.href ="/board/register"
	 });
	 	
	var actionForm = $("#actionForm");
	
	/* paginate_button 클래스의 버튼을 클릭 할 때의 처리*/
	$(".paginate_button a").on("click", function(e){
		
		e.preventDefault();
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	});
	
	/* 게시물의 제목을 클릭하면 이동하는 a태그를 막고
	   actionForm을 활용하여 페이지번호, 검색필터 심어주기 */
	$(".move").on("click",function(e){
			
		e.preventDefault();
		actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
		actionForm.attr("action","/board/get");
		actionForm.submit();
	});
	
	/* 키워드와 검색종류 설정 안하면 검색 X */
	var searchForm = $("#searchForm");
	
	$("#searchForm button").on("click", function(e){
		
		if(!searchForm.find("option:selected").val()){
			alert("검색종류를 선택하세요");
			return false;
		}
		
		if(!searchForm.find("input[name='keyword']").val()){
			alert("키워드를 입력하세요");
			return false;
		}
		
		/* 검색에 성공하면 1페이지로 넘어간다 */
		searchForm.find("input[name='pageNum']").val("1");
		e.preventDefault();
		
		searchForm.submit();
	});	
		
 });
 
 </script>
                

 <%@include file="../includes/footer.jsp"%>