<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.koreait.web.BoardVO"%>

<%! 
	private Connection getCon() throws Exception {
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
	List<BoardVO> boardList = new ArrayList();
	Connection con = null; // 연결 담당
	PreparedStatement ps = null; // 쿼리문 완성 + 쿼리문 실행
	ResultSet rs = null; // select문의 결과를 담는 과정
	
	String sql = " SELECT i_board, title FROM t_board ORDER BY i_board DESC ";
	// 쿼리문 양쪽에는 웬만하면 빈칸 하나씩 두기
	// 여러 줄에 걸쳐서 쓸 때도 빈칸 넣기
	// " SELECT i_board, title " + " FROM t_board ";
	// 쿼리문 뒤에 세미콜론을 넣으면 실행이 안 되도록 함
	
	try {
		con = getCon();
		ps = con.prepareStatement(sql);
		rs = ps.executeQuery(); // select문만!!!!!!!!!!!!!!!!!!!!!
		
		while(rs.next()) {	// rs.next()를 실행하는 순간 첫번째 줄을 가리킴
							// 다음 rs.next()를 실행했는데 다음 줄이 있으면 true 리턴, 없으면 false 리턴
							// 보통 rs는 이 while문과 같이 씀
							// 한 줄만 가져와야 할 땐 if문과 같이 씀
			int i_board = rs.getInt("i_board");	// getInt의 인자값은 컬럼명
			String title = rs.getNString("title");	// getNString이나 getString 둘 다 똑같음, 인자값 컬럼명
			
			BoardVO vo = new BoardVO();	// ☆★☆★☆★☆★☆★☆★☆★☆★☆★
										// while문 밖에서 선언하면 똑같은 내용만 나옴
			vo.setI_board(i_board);
			vo.setTitle(title);
			
			boardList.add(vo);
		}
		
	} catch(Exception e) {
		e.printStackTrace();
	} finally {
		if(rs != null) { try { rs.close(); } catch(Exception e) {} }
		if(ps != null) { try { ps.close(); } catch(Exception e) {} }
		if(con != null) { try { con.close(); } catch(Exception e) {} }
	}
	// 열었으면 꼭 닫아주기!!!! 순서는 여는 순서와 반대로 닫기
	// 다 같이 묶어주면 셋 중에 하나만 에러가 나도 나머지는 close가 실행되지 않고 바로 catch문으로 넘어가버림
	// 안 닫아주면 서버 죽음
	
	// /jsp/boardDetail.jsp?i_board=<%=vo.getI_board() 여기서 ? 뒤에는 쿼리스트링
			// ?는 쿼리스트링을 시작하겠다는 의미
			// 키값=밸류
			// & - 키값과 밸류를 더 보내고 싶을 때 쓰는 연결자
			// get 방식 - 주소에 쿼리스트링이 노출되는 방식(속도 중요)
			// host 방식 - 주소에 쿼리스트링이 노출되지 않는 방식(보안 중요)
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
<style>
	body {
		width: 100%;
		height: 100%;
		margin: 0;
		padding: 0;
	}
	.container {
		width: 500px;
		height: 500px;
		border: 1px solid black;
		display: flex;
        justify-content: center;
        align-items: center;
	}
	.container .contents {
		width: auto;
		border: 3px solid black;
	
	}
	.container .contents .header {
		width: 100%;
		display: flex;
		justify-content: flex-end;
	}
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
		<div class="contents">
		<p>게시판 리스트</p>
			<header class="header">
				
				<a href="/jsp/boardWrite.jsp"><button>글쓰기</button></a> <!-- 글쓰는 화면 띄우는 용도인 boardWrite.jsp와 -->
					<!-- 폼으로 받아서 insert 날리고 실제 처리하는 boardWriteProc.jsp 파일 두 개가 필요함 -->
			</header>
			<table>
				<tr>
					<th>No</th>
					<th>제목</th>
				</tr>
				<% for(BoardVO vo : boardList) {%>
				<tr>
					<td><%=vo.getI_board() %></td>
					<td><a href="/jsp/boardDetail.jsp?i_board=<%=vo.getI_board() %> " target="_blank">
						<%=vo.getTitle() %> 
						</a>
					</td>
				</tr>
				<% } %> 
			</table>
		</div>
	</div>
</body>
</html>

