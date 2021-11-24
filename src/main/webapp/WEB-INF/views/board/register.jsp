<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp" %>



<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시글 등록</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">게시글 등록</div>
			<!-- /.panel-heading -->
			<div class="panel-body">
			
				<!-- 폼태그를 이용해 POST 메소드로 /board/register 요청해 등록작업 완료 -->
				<form role="form" action="/board/register" method="post">
				
				<input type="hidden" name="{_csrf.parameterName}" value="{_csrf.token}" >
				
					<div class="form-group">
						<label>제목</label> <input class="form-control" name="title">
					</div>
					
					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" rows="7" name="content"></textarea>
					</div>
					<div class="form-group">
						<label>작성자</label> <input class="form-control" name="writer"
						value='<sec:authentication property="principal.username" /> ' readonly="readonly">
					</div>
					
					<button type="submit" class="btn btn-default">작성하기</button>
					<button type="reset" class="btn btn-default">다시 작성</button>
				</form>
			
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- ./panel body -->
	</div>
	<!-- ./panel -->
</div>
<!-- ./row  -->

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
		
			<div class="panel-heading">파일 업로드</div>
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


<script
  src="https://code.jquery.com/jquery-3.6.0.min.js"
  integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4="
  crossorigin="anonymous">
</script>


<script>
	
	$(document).ready(function(e){
		
		var formObj = $("form[role='form']");
		
		$("button[type='submit']").on("click",function(e){
			
			e.preventDefault();
			
			console.log("submit clicked");
			
			var str="";
			
			$(".uploadResult ul li").each(function(i, obj){
				
				var jobj = $(obj);
				
				console.dir(jobj);
				
				str+= "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str+= "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str+= "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str+= "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
			});
			
			/* 브라우저에서 게시물 등록을 선택하면 이미 업로드된 항목들을 내부적으로 hidden타입으로 만들어서 submit될 때 같이 전송 */
			formObj.append(str).submit();
		});
	});

</script>

  
 <script>
 	$(document).ready(function(){
 		
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
		
		
		$(".uploadResult").on("click","button",function(e){
			
			console.log("delete file");
			
			var targetFile = $(this).data("file");
			
			var type = $(this).data("type");
			
			var targetLi = $(this).closest("li");
			
			$.ajax({
				
				url : "/deleteFile",
				data : {fileName : targetFile, type:type},
				beforeSend: function(xhr){
 					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
 				},
				dataType : "text",
				type : "POST",
				success : function(result){
					alert(result);
					targetLi.remove();
				}
			});
			
		});
 		
 		
 	});
 
 </script>
 
 <script>
 
 	function showImage(fileCallPath){
 		
 		$(".bigPictureWrapper").css("display","flex").show();
 		
 		$(".bigPicture")
 		.html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>")
 		.animate({width:"100%", height: "100%"},1000);
 		
 	
 		$(".bigPictureWrapper").on("click",function(e){
 			
 			$(".bigPicture").animate({width:"0%", height:"0%"},1000);
 			setTimeout(function(){
 				$(".bigPictureWrapper").hide();
 			},1000);
 		});
 		
 		
 	}
 
 </script>
 


<%@include file="../includes/footer.jsp" %>