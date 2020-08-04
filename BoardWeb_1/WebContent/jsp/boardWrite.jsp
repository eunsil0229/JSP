<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String msg = "";
	String err = request.getParameter("err");
	if(err != null) {
		switch(err) {
		case "10":
			msg = "등록할 수 없습니다.";
			break;
		case "20":
			msg = "DB 에러 발생";
			break;
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<style>
	#msg {
		color: red;
	}
</style>
</head>
<body>
	<div id="msg"><%=msg %></div>
	<div>
		<form id="frm" action="/jsp/boardWriteProc.jsp" method="post" onsubmit="return chk()"> 
		<!-- method는 post 방식과 get 방식을 정해주는 것 -->
		<!-- name은 서버한테 값을 날릴 때 key값으로 사용됨 , JS와 CSS에서는 안 쓰임-->
			<div>
				<label>제목 : <input type="text" name="title"></label>
			</div>
			<div>
				<label>내용 : <textarea name="ctnt"></textarea></label>
			</div>
			<div>
				<label>작성자 : <input type="text" name="i_student"></label>
			</div>
			<div>
				<input type="submit" value="글등록">
			</div>
		</form>
		<button onclick="location.href='/jsp/boardlist.jsp'" >글목록</button>
		<script>
			function eleValid(ele, nm) {
				if(ele.value.length == 0) {
					alert(nm+'을(를) 입력해주세요.');
					ele.focus();
					return true;
				}
			}
			
			function chk() {
				console.log(`title: \${frm.title.value}`);
				
				if(eleValid(frm.title, '제목')) {
					return false
				} else if(eleValid(frm.ctnt, '내용')) {
					return false
				} else if(eleValid(frm.i_student, '작성자')) {
					return false
				}
			}
			
			/*
			function chk() {
				console.log(`title: \${frm.title.value}`);
				
				if(frm.title.value === '') {
					alert('제목을 입력해주세요.');
					frm.title.focus();
					return false;
				} else if(frm.ctnt.value.length === 0) {
					alert('내용을 입력해주세요.');
					frm.ctnt.focus();
					return false;
				} else if(frm.i_student.value === 0) {
					alert('작성자를 입력해주세요.');
					frm.i_student.focus();
					return false;
				}
			}
			*/
		</script>
	</div>
	<!-- 값 입력 담당, 값 처리 담당 나누는 것이 좋음 -->
</body>
</html>