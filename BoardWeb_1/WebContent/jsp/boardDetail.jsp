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

	BoardVO vo = null;
	Connection con = null; // 연결 담당
	PreparedStatement ps = null; // 쿼리문 완성 + 쿼리문 실행
	ResultSet rs = null; // select문의 결과를 담는 과정
	
	String name = "";
	
	String sql = " SELECT title, ctnt, i_student FROM t_board WHERE i_board = " + strI_board;
	sql = " SELECT a.i_student as I_STUDENT, title, ctnt, nm FROM t_board A JOIN T_STUDENT B ON A.i_student = B.i_student WHERE i_board = " + strI_board;
	
	try {
		con = getCon();
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		
		rs.next();
		
		
		// int i_board = rs.getInt("i_board");
		String title = rs.getNString("title");
		String ctnt = rs.getNString("ctnt");
		int i_student = rs.getInt("i_student");
		name = rs.getNString("nm");
		
		vo = new BoardVO();
		
		//  vo.setI_board(i_board);
		vo.setTitle(title);
		vo.setCtnt(ctnt);
		vo.setI_student(i_student);
		
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

	
</body>
</html>