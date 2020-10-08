<%
	String str = request.getParameter("query_val");
	out.println("str:"+str);
%>
<html>
<head></head>
<body>
<form name="test_form" method="post" action="test.jsp">
<input type=file name=browse style="display: none;">
<input type=text name=file value=<%=str%>>
<input type=button
style="font-style:veranda; font-size:12px; font-weight:bold;text-transform:lowercase;color:white;background-color:#A2C382;height:22px;border-style:ridge;text-align:center;"
onClick="browse.click();file.value=browse.value;"
value="Select a File...">
<br><br>
<!-- must be clicked twice for the form to submit! -->
<input type=submit
value="Submit The Form Now!"
style="font-style:veranda; font-size:12px;">
</form>
</body>
</html>