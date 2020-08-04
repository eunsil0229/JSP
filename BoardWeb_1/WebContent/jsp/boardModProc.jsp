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
	// 외부로부터 값을 받아오기 위해
	// key:value	-> "title":title의 value값
	// request에 담겨 있는 주소값(http servlet 객체의 주소값)
	String title = request.getParameter("title");
	String ctnt = request.getParameter("ctnt");
	String strI_student = request.getParameter("i_student");
	String strI_board = request.getParameter("i_board");
	int i_board = Integer.parseInt(strI_board);

    if("".equals(title) || "".equals(ctnt) || "".equals(strI_student)) {
	      response.sendRedirect("/jsp/boardMod.jsp?err=10");
	      return;
	 }
    
    int i_student = Integer.parseInt(strI_student);

	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null; // select문일 때만 필요함

	
	String sql = " UPDATE t_board SET title = ?, ctnt = ?, i_student = ? WHERE i_board = ? ";
	
	
	int count = -1;
	
	try {
		con = getCon();
		ps = con.prepareStatement(sql);
		
		ps.setString(1, title);
		ps.setString(2, ctnt);
		ps.setInt(3, i_student);
		ps.setInt(4, i_board);
		
		count = ps.executeUpdate();		
		

		
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs != null) { try { rs.close(); } catch(Exception e) {} }
		if(ps != null) { try { ps.close(); } catch(Exception e) {} }
		if(con != null) { try { con.close(); } catch(Exception e) {} }
	}	
	
	/*
	switch(count) {
	case -1:
		response.sendRedirect("/jsp/boardlist.jsp");
		break;
	case 0:
		response.sendRedirect("/jsp/boardlist.jsp");
		break;
	case 1:
		response.sendRedirect("/jsp/boardDetail.jsp?i_board=" + i_board);
		break;
	}
	*/
	
	int err = 0;
	switch(count) {
	case 1:
		response.sendRedirect("/jsp/boardDetail.jsp?i_board=" + i_board);
		return;
	case 0:
		err = 10;
		response.sendRedirect("/jsp/boardMod.jsp?err=10&i_board=" + i_board);
		break;
	case -1:
		err = 20;
		response.sendRedirect("/jsp/boardMod.jsp?err=20&i_board=" + i_board);
		break;
	}
	
%>