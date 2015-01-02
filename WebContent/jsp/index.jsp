<%@ page language="java" contentType="text/html; charset=US-ASCII"
    pageEncoding="US-ASCII"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<% 
boolean isAdmin = false;
if (request.getParameter("admin") != null) {
	if (request.getParameter("admin").equals("uboot")) {
		isAdmin = true;
	}
}
if (isAdmin) {
	out.println("<title>[ADMIN] Stonefish Control Panel</title>");
	out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"jsp/style/base.css\"> ");
	out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"jsp/style/admin_panel.css\"> ");
} else {
	out.println("<title>Stonefish Control Panel</title>");
	out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"jsp/style/base.css\"> ");
	out.println("<link rel=\"stylesheet\" type=\"text/css\" href=\"jsp/style/user_panel.css\"> ");
}

%>
</head>

<body>
	<div id="main">
		<% if(isAdmin) { %>
			<jsp:include page="admin.jsp"></jsp:include>
		<% } else { %>
			<jsp:include page="user.jsp"></jsp:include>
		<% } %>
	</div>
</body>
</html> 
