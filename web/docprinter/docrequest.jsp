<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.printer.DbDocPrinter" %>
<%@ page import = "com.project.printer.DocPrinter" %>
<%@ page import = "com.project.util.JSPCommand" %>
<%
	String strQuery = "PRINTING...";
	String command = request.getParameter("command");
	String docCode = request.getParameter("doc_code");
	String docId = request.getParameter("doc_id");
        String hostPrinter = request.getParameter("host_printer");
        String docUserId = request.getParameter("doc_user_id");

	try{
		if(Integer.parseInt(command)==JSPCommand.SUBMIT){
			DbDocPrinter.insertDocToPrint(docCode,Long.parseLong(docId),"",Long.parseLong(docUserId));
		}
	}catch(Exception e){
		System.out.println("err"+e.toString());
	}
%>
<%=strQuery%>
<script language="JavaScript">
	window.close();
</script>