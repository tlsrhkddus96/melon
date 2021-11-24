/**
 * 
 */

var replyService = (function(){
	
	//댓글 등록
	function add(reply, callback, error){	

		
		$.ajax({
			type : "post",					//전송 방식
			url : "/replies/new",			//전송 페이지
			data : JSON.stringify(reply),	//전송할 데이터  > JSON.stringify를 사용해 객체를 문자열 데이터로 반환
			contentType : "application/json; charset=utf-8",	//데이터의 content-type 지정 
			success : function(result, status, xhr){	//AJAX 통신이 정상적으로 이뤄질 경우 이벤트
				if(callback){
					callback(result);
				}
			},
			error : function(xhr, status, er){			//통신에 문제가 발생했을 때의 이벤트
				if(error){
					error(er);
				}
			}
		})
	}
	
	//댓글 목록
	function getList(param, callback, error){	//param이라는 객체를 통해서 필요한 파라미터를 전달받아 JSON목록 호출
		
		var bno = param.bno;	
		var page = param.page || 1;
		
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",	//getJSON 메소드를 사용했으므로 확장자 .json을 요청한다. 
			function(data){
				if(callback){
					callback(data.replyCnt, data.list); //댓글 숫자와 목록을 가져온다
				}
			}).fail(function(xhr, status, er){
				if(error){
					error(er);
				}
			});
	}
	
	//댓글 삭제
	function remove(rno, replyer, callback, error){
		
		$.ajax({
			type : 'delete',			//전송 방식
			url : '/replies/' + rno,	//전송 페이지
			data : JSON.stringify({rno:rno, replyer:replyer}),
			contentType: "application/json; charset=utf-8",
			
			success : function(deleteResult, status, xhr){
				if(callback){
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	//댓글 수정
	function update(reply, callback, error){
		
		console.log("RNO : " + reply.rno);
		
		$.ajax({
			type : 'put',
			url : '/replies/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback){
					callback(result);
				}
			},
			error : function(xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	//댓글 조회
	function get(rno, callback, error){
		
		$.get("/replies/" + rno + ".json", function(result){
			
			if(callback){
				callback(result);
			}
		}).fail(function(xhr, status, err){
			if(error){
				error();
			}
		});
	}
	
	//시간에 대한 처리
	function displayTime(timeValue){
		
		var today = new Date();
		
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str = "";
		
		if (gap < (1000*60*60*24)){
			
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
			return [ (hh>9 ? "":"0") + hh, ":", (mi > 9 ? "":"0") + mi, ":", (ss > 9 ? "":"0") +ss].join("");
		
		}else{
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			return [yy, "/" , (mm>9 ? "": "0") + mm, "/", (dd > 9 ?"" : "0") + dd].join("");
		}
	};
	
	
	return {
		add:add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime : displayTime
	};
})();