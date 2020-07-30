<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
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
	int i_board = Integer.parseInt(strI_board);
	// strI_board가 null이 아닌지 체크, 문자열이 안 섞여있는지 체크,
	// 예외처리 해줌
	
	// BoardVO vo = new BoardVO();
	Connection con = null; 
	PreparedStatement ps = null; 
	// ResultSet rs = null; 

	String sql = " DELETE FROM t_board WHERE i_board = ? ";	
	
	int count = -1;
	
	
	try {
		con = getCon();
		ps = con.prepareStatement(sql);
		ps.setInt(1, i_board);

		count = ps.executeUpdate();

		
		
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		//if(rs != null) { try { rs.close(); } catch(Exception e) {} }
		if(ps != null) { try { ps.close(); } catch(Exception e) {} }
		if(con != null) { try { con.close(); } catch(Exception e) {} }
	}
	
	System.out.println("result : " + count);
	

	switch(count) {
		case -1:
			response.sendRedirect("/jsp/boardDetail.jsp?err=-1&i_board=" + i_board);
			// 우리에게 결과가 오지 않고 바로 주소 이동을 함
			break;
		case 0:
			response.sendRedirect("/jsp/boardDetail.jsp?err=0&i_board=" + i_board);
			break;
		case 1:
			response.sendRedirect("/jsp/boardlist.jsp");
			break;
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상세 페이지</title>

</head>
<body>
<!-- 
	<script>
		if(<%=count%>==0) {
			alert("삭제할 행이 없습니다.")
		} else if(<%=count%>==-1){
			alert("삭제할 수 없습니다.")
		} else {
			alert("삭제했습니다.")
		}
	</script>
	 -->
</body>
</html>