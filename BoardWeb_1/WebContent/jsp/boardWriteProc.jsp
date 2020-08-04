<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%!
	// 한글 깨짐 방지 방법1 (2는 서버 자체에 UTF-8 인코딩을 해줌)
	// 톰캣에서는 get 방식에 대한 encoding을 해줬음
	// post 방식에 대한 encoding은 web-inf/lib/web.xml
	//request.setCharacterEncoding("UTF-8");
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
	int i_board = 0;

    if("".equals(title) || "".equals(ctnt) || "".equals(strI_student)) {
	      response.sendRedirect("/jsp/boardWrite.jsp?err=10");
	      return;
	 }
    
    int i_student = Integer.parseInt(strI_student);

	Connection con = null;
	PreparedStatement ps = null;
	ResultSet rs = null; // select문일 때만 필요함

	
	String sql = " INSERT INTO t_board (i_board, title, ctnt, i_student) "
			+ " SELECT nvl(max(i_board),0)+1, ?, ?, ? " 
			+ " FROM t_board ";
	
	
	int count = -1;
	
	try {
		con = getCon();
		ps = con.prepareStatement(sql);
		
		ps.setString(1, title);
		ps.setString(2, ctnt);
		ps.setInt(3, i_student);
		
		count = ps.executeUpdate();		
		
		sql = " SELECT nvl(max(i_board),0) as boardNum FROM t_board ";
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery();
		
		if(rs.next()) {
			i_board = rs.getInt("boardNum");
		}
		
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
		response.sendRedirect("/jsp/boardlist.jsp");
		return;
	case 0:
		err = 10;
		break;
	case -1:
		err = 20;
		break;
	}
	response.sendRedirect("/jsp/boardWrite.jsp?err=" + err);
%>