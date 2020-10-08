
<%@ page language="java" import="java.sql.ResultSet"%>
<%@ page language="java" import="java.sql.ResultSetMetaData"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>

<%
    int iCommand = JSPRequestValue.requestCommand(request);    
    
    String sql = request.getParameter("txtquery");
    ResultSet rs = null;
    if(sql==null) 
            sql = "";
    
    if(sql!=null && sql.length()>0){        
        if(iCommand==1){
            CONResultSet dbrs = CONHandler.execQueryResult(sql); 
            rs = dbrs.getResultSet();
        }else if(iCommand==2){
            int xx = CONHandler.execUpdate(sql); 
        }
    }
%>
<html>
<head>
<title>Query Execute...</title>

<script language="JavaScript">
    
    function executeQuery(idx){
        if(document.frmexecute.txtquery.value !=''){
            document.frmexecute.command.value =idx;            
            document.frmexecute.submit();
        }    
    }
</script>     
</head>

<body>
<form name="frmexecute" method="post" action="">
<input type="hidden" name="command" value="">    
<table width="100%" border="0">
  <tr>
    <td width="53%" bgcolor="#CCCCCC">SQL Execute ... </td>
    <td width="47%">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">
      <label>
        <textarea name="txtquery" cols="80" rows="20"><%=sql%></textarea>
        </label>    </td>
    <td valign="top">
      <label>&nbsp;
      <input type="button" name="Submitxx" value="Execute Query" onclick="javascript:executeQuery(1)" />
	  execute for select <br>
	  <br><br><br><br><br><br>&nbsp;&nbsp;<input type="button" name="Submit" value="Execute Update" onclick="javascript:executeQuery(2)" />
        </label> 
      execute for update or delete </td>
  </tr>
  <tr>
    <td colspan="2">Result Query ... </td>
    </tr>
  <tr>
    <td colspan="2"><hr width="100%"></td>
  </tr>
  <tr>
    <td colspan="2">
        
        <%
            if(rs!=null) {
                //System.out.println(rs);
                
            int i = 0;    
            out.println("<table width=\"100%\" border=\"1\">");
                if(iCommand==1) {
                    while(rs.next()){
                        //System.out.println("2 : "+rs);
                        ResultSetMetaData meta = rs.getMetaData();
                       // System.out.println("meta : "+meta);
                        int col = meta.getColumnCount();
                        //System.out.println("col : "+col);
                        if(i==0){
                            out.println("<tr>");
                            for(int k=0;k<col;k++){
                                out.println("<td bgcolor=\"#CCCCCC\" width=\"10%\">");
                                out.println(meta.getColumnName(k+1));
                                out.println("</td>");
                            }
                            out.println("</tr>");
                        }

                        out.println("<tr>");
                        for(int k=0;k<col;k++){
                            out.println("<td>"+rs.getObject(meta.getColumnName(k+1))+"</td>");
                        }
                        out.println("</tr>");
                        i++;
                    }
              }else{
                out.println("<tr>");
                    out.println("<td>OK</td>");
                out.println("</tr>");
              }
            out.println("</table>");
        }
        %>    </td>
    </tr>
</table>
</form>
</body>
</html>
