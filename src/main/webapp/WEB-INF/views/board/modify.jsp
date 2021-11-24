<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%@include file="../includes/header.jsp" %>



<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시물 수정/삭제</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">게시물 수정/삭제</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
			
			<!-- action속성을 /board/modify 로 지정했지만, 삭제 버튼을 누르면 JS를 이용해 /board/remove로 이동하게 끔 작성  -->
			<form role="form" action="/board/modify" method="post">
			
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
				
				<input type="hidden" name="pageNum" value='<c:out value="${cri.pageNum }"/>'>
				<input type="hidden" name="amount" value='<c:out value="${cri.amount }"/>'>
				<input type="hidden" name="type" value='<c:out value="${cri.type }"/>'>
				<input type="hidden" name="keyword" value='<c:out value="${cri.keyword }"/>'>
			
					<div class="form-group">
						<label>게시물 번호</label> <input class="form-control" name="bno"
						value='<c:out value="${board.bno }"/>' readonly="readonly">
					</div>
			
					<div class="form-group">
						<label>제목</label> <input class="form-control" name="title"
						value='<c:out value="${board.title }"/>'>
					</div>
			
					<div class="form-group">
						<label>내용</label>
						 <textarea class="form-control" rows="7" name="content">
						 <c:out value="${board.content }"/></textarea>
					</div>
			
					<div class="form-group">
						<label>작성자</label> <input class="form-control" name="writer"
						value='<c:out value="${board.writer }"/>' readonly="readonly">
					</div>
					
					<div class="form-group">
						<label>등록일</label>
						<input class="form-control" name="regDate"
						value='<fmt:formatDate pattern = "yyyy/MM/dd" value="${board.regdate }"/>' readonly="readonly">
					</div>
					
					<div class="form-group">
						<label>수정일</label>
						<input class="form-control" name="updateDate"
						value='<fmt:formatDate pattern = "yyyy/MM/dd" value="${board.updateDate }"/>' readonly="readonly">
					</div>
					
					
					<sec:authentication property="principal" var="pinfo"/>
					
					<sec:authorize access="isAuthenticated()">
						<c:if test="${pinfo.username ne board.writer}">
					
							<button type="submit" data-oper="modify" class="btn btn-default">수정</button>
							<button type="submit" data-oper="remove" class="btn btn-danger">삭제</button>

						</c:if>
					</sec:authorize>

					<button type="submit" data-oper="list" class="btn btn-info">목록</button>
					
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
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
			
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


<%@include file="../includes/footer.jsp" %>


<script type="text/javascript">
	$(document).ready(function(){
		
		var formObj = $("form");
		
		$("button").on("click",function(e){
			
			/* button태그를 클릭시 기본 동작을 막는 메소드 */
			e.preventDefault();
			
			/* button태그의 data-oper속성을 이용해 각각 원하는 기능 수행하도록 변경 */
			var operation = $(this).data("oper");
			
			/* data-oper속성 값이 remove인 경우
			form태그의 action속성 값을 /board/modify에서 /board/remove로 변경*/
			if(operation == "remove"){
				formObj.attr("action", "/board/remove");
				
			/* data-oper속성 값이 list인 경우
			form태그 action속성 값을 /board/list , 그리고 메소드를 GET방식으로 변경*/	
			}else if(operation == "list"){
				formObj.attr("action","/board/list").attr("method","get");
				
				/* 페이징과 검색필터 태그를 clone을 통해 보관해두고 empty를 이용해 모든 내용을 지운다.
				   후에 다시 필요한태그를 추가해서 /board/list를 호출한다.*/
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				
				formObj.empty();
				
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			
			/* modify인 경우 히든태그로 첨부파일의 정보또한 같이 보낸다*/	
			}else if(operation =="modify"){

				var str="";
				
				$(".uploadResult ul li").each(function(i, obj){
					
					var jobj = $(obj);
					
					console.dir(jobj);
					
					str+= "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str+= "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str+= "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str+= "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				});
				
				formObj.append(str).submit();
				
			}
			
			/* 위의 작업이 완료되면 직접 submit */
			formObj.submit();
			
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
						
						var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid+ "_"+ attach.fileName);
						
						str+= "<li data-path='"+attach.uploadPath+"'";
						str+= " data-uuid='"+attach.uuid+"' data-filename= '"+attach.fileName+"' data-type='"+attach.fileType+"'"
						str+= " ><div>";
						str+= "<span>"+ attach.fileName +"</span>";
						str+= "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'>"
								+"<i class='fa fa-times'></i></button><br>";
						str+= "<img src='/display?fileName="+fileCallPath+"'>";
						str+= "</div>";
						str+= "</li>";
						
					} else {
						
						str+= "<li data-path='"+attach.uploadPath+"'";
						str+= " data-uuid='"+attach.uuid+"' data-filename= '"+attach.fileName+"' data-type='"+attach.fileType+"'"
						str+= " ><div>";
						str+= "<span>"+ attach.fileName +"</span><br>";
						str+= "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'>"
								+"<i class='fa fa-times'></i></button><br>";
						str+= "<img src='/resources/img/attach.png'>";
						str+= "</div>";
						str+= "</li>";
					}
				});
				
				$(".uploadResult ul").html(str);
				
			});//end getjson
		
		})();//end function
		
		
		//첨부파일 x버튼 클릭시 이벤트
		$(".uploadResult").on("click", "button" ,function(e){
			
			console.log("delete file");
			
			if(confirm("파일을 삭제하시겠습니까?")){
				
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});
		
		
	 	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	 	var maxSize = 5242880;
	 	
	 	function checkExtension(fileName, fileSize){
	 		
	 		if(fileSize >= maxSize){
	 			alert("파일 사이즈 초과");
	 			return false;
	 		}
	 		
	 		if(regex.test(fileName)){
	 			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
	 			return false;
	 		}
	 		return true;
	 	}
 	
 		
	 	var csrfHeaderName ="${_csrf.headerName}";
	 	var csrfTokenValue ="${_csrf.token}";
	 	
 		$("input[type='file']").change(function(e){
 			
 			
 			var formData = new FormData();
 			
 			var inputFile = $("input[name='uploadFile']");
 			
 			var files = inputFile[0].files ;
 			
 			for(var i=0; i< files.length; i++){
 				
 				if(!checkExtension(files[i].name, files[i].size) ){
 					return false;
 				}
 				
 				formData.append("uploadFile", files[i]);
 			}
 			
 			$.ajax({
 				
 				url : '/uploadAjaxAction' ,
 				processData: false,
 				contentType: false,
 				beforeSend: function(xhr){
 					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
 				},
 				data : formData,
 				type : 'POST',
 				dataType : 'json',
 				success : function(result){
 					
 					console.log(result);
 					showUploadResult(result);
 					
 				}
 			});
 			
 		});
 		
 		
		function showUploadResult(uploadResultArr){
			
			if(!uploadResultArr || uploadResultArr.length == 0){
				
				return;
			}
			
			var uploadUL = $(".uploadResult ul");
			
			var str = "";
			
			
			$(uploadResultArr).each(function(i, obj){
				
				if(obj.image){
					
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid+ "_"+ obj.fileName);
					
					str+= "<li data-path='"+obj.uploadPath+"'";
					str+= " data-uuid='"+obj.uuid+"' data-filename= '"+obj.fileName+"' data-type='"+obj.image+"'"
					str+= " ><div>";
					str+= "<span>"+ obj.fileName +"</span>";
					str+= "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'>"
							+"<i class='fa fa-times'></i></button><br>";
					str+= "<img src='/display?fileName="+fileCallPath+"'>";
					str+= "</div>";
					str+= "</li>";
					
				} else {
					
					var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid+ "_"+ obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

					str+= "<li data-path='"+obj.uploadPath+"'";
					str+= " data-uuid='"+obj.uuid+"' data-filename= '"+obj.fileName+"' data-type='"+obj.image+"'"
					str+= " ><div>";
					str+= "<span>"+ obj.fileName +"</span>";
					str+= "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'>"
							+"<i class='fa fa-times'></i></button><br>";
					str+= "<img src='/resources/img/attach.png'>";
					str+= "</div>";
					str+= "</li>";
				}
			});
			
			uploadUL.append(str);
		}
		
	});
</script>