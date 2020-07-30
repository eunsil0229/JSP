<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="com.koreait.web.BoardVO"%>
<%! 
	Connection getCon() throws Exception {
		String url = "jdbc:oracle:thin:@localhost:1521:orcl";
		String username = "hr";
		String password = "koreait2020";
		
		Class.forName("oracle.jdbc.driver.OracleDriver");
		
		Connection con = DriverManager.getConnection(url, username, password);
		System.out.println("접속 성공!");
		
		return con;
	}
%>
<%
	String strI_board = request.getParameter("i_board");
	if(strI_board == null) {
%>
	<script>
		alert('잘못된 접근입니다.')
		location.href='/jsp/boardlist.jsp'
	</script>

<%
		return;
	}
	int i_board = Integer.parseInt(strI_board);

	BoardVO vo = new BoardVO();
	Connection con = null; // 연결 담당
	PreparedStatement ps = null; // 쿼리문 완성 + 쿼리문 실행
	ResultSet rs = null; // select문의 결과를 담는 과정
	
	String name = "";
	
	String sql = " SELECT title, ctnt, i_student FROM t_board WHERE i_board = " + strI_board;
	//sql = " SELECT a.i_student as I_STUDENT, title, ctnt, nm FROM t_board A JOIN T_STUDENT B ON A.i_student = B.i_student WHERE i_board = " + strI_board;
	sql = " SELECT title, ctnt, i_student FROM t_board WHERE i_board = ? ";
	sql = "SELECT a.i_student as I_STUDENT, title, ctnt, nm FROM t_board A JOIN T_STUDENT B ON A.i_student = B.i_student WHERE i_board = ? ";
	
	try {
		con = getCon();
		ps = con.prepareStatement(sql);
		ps.setInt(1, i_board);			// 첫번째 물음표에 i_board를 넣어줌
		//ps.setString(1, strI_board);	// 첫번째 물음표에 strI_board를 넣어줌
										// String이라서 자동으로 '' 홑따옴표로 감싸줌
										// setString 해도 문제는 없지만 정수니까 int로!
		
		rs = ps.executeQuery();			// 쿼리문 실행 - 무조건 물음표 처리 후 실행해야 함
		
		if(rs.next()) {	// 몇 줄이든 간에 한 번은 실행이 되어야 함
						// 처음 실행하면 첫 줄을 가리킴
			// int i_board = rs.getInt("i_board");
			String title = rs.getNString("title");
			String ctnt = rs.getNString("ctnt");
			int i_student = rs.getInt("i_student");
			name = rs.getNString("nm");
			
			
			//  vo.setI_board(i_board);
			vo.setTitle(title);
			vo.setCtnt(ctnt);
			vo.setI_student(i_student);
		}
		
		
		// boardDel.jsp 파일 만들고 삭제 - ps.executeUpdate 사용-> 리턴 타입 int -> 몇 개 행에 영향을 미쳤는지
		// 몇 개 행을 삭제했는지 
		
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs != null) { try { rs.close(); } catch(Exception e) {} }
		if(ps != null) { try { ps.close(); } catch(Exception e) {} }
		if(con != null) { try { con.close(); } catch(Exception e) {} }
	}
	
	// 연결했는데 또 연결해주는 이유	-> 쓰자마자 close() 해서 닫았기 때문
	// 타이틀도 getParameter로 받을 수 있는가	-> 받아올 수는 있지만 트래픽 발생이 많고 비효율적이라 pk값을 받아오는 것이 좋음
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세 페이지</title>
<style>
	
    table {
        border-collapse: collapse;
    }
    tr, td, th {
        border: 1px solid black;
        width: 100px;
        text-align: center;
    }
</style>
</head>
<body>
	<div class="container">
	<div>
	<a href="/jsp/boardlist.jsp">리스트로 가기</a>
	<a href="#" onclick="procDel(<%=i_board%>)">삭제</a>
	</div>
		<table>
			<caption>상세 페이지 : <%=strI_board %></caption>
	        <tr>
	            <th>글 번호</th>
	            <th>글 제목</th>
	            <th>글 내용</th>
	            <th>작성자</th>
	        </tr>
	        <tr>
	            <td><%=strI_board %></td>
	            <td><%=vo.getTitle() %></td>
	            <td style="width: 200px"><%=vo.getCtnt() %></td>
	            <td><%=name %></td>
	        </tr>
	    </table>
	</div>
	<script>
		function procDel(i_board) {
			alert('i_board : ' + i_board)
			var result = confirm('삭제하시겠습니까?')
			if(result) {
				location.href = '/jsp/boardDel.jsp?i_board=' + i_board
			}
		}
	</script>
	
</body>
</html>