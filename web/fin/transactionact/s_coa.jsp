
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.main.entity.*" %>
<%@ page import = "com.project.admin.*" %>
<%@ page import = "com.project.general.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.*" %>
<%@ include file = "../main/javainit.jsp" %> 
<%@ include file = "../main/check.jsp" %>
<%
            boolean privAdd = true;
            boolean privUpdate = true;
            boolean privDelete = true;
%>
<!-- Jsp Block -->
<%
            String formName = JSPRequestValue.requestString(request, "formName");
            String accId = JSPRequestValue.requestString(request, "accId");
            String accName = JSPRequestValue.requestString(request, "accName");

            Coa objCoa = new Coa();
            Vector listCoa = new Vector(1, 1);

            listCoa = DbCoa.list(0, 0, "", DbCoa.colNames[DbCoa.COL_CODE]);

%>
<html ><!-- #BeginTemplate "/Templates/index.dwt" -->
    <head>
        <!-- #BeginEditable "javascript" --> 
        <title><%=systemTitle%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link href="../css/default.css" rel="stylesheet" type="text/css" />
        <link href="../css/css.css" rel="stylesheet" type="text/css" />
        <script language="JavaScript">
            
            function cmdSelect(accid, accname){                
                self.opener.document.<%=formName%>.<%=accId%>.value = accid;
                self.opener.document.<%=formName%>.<%=accName%>.value = accname;                
                self.close();
            }
        </script>
        <style type="text/css">
            <!--
            .style1 {color: #FF0000}
            -->
        </style>
        <!-- #EndEditable -->
    </head>
    <body> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td width="5px">&nbsp;</td>
                <td><font class="lvl1"><b>Daftar Perkiraan</b></font></td>
            </tr>
            <tr>
                <td width="5px">&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr> 
                <td width="5px">&nbsp;</td>
                <td><!-- #BeginEditable "content" --> 
                    <form name="frm_scoa" method ="post" action="">
                        <%
            if (listCoa != null && listCoa.size() > 0) {
                for (int i = 0; i < listCoa.size(); i++) {
                    objCoa = (Coa) listCoa.get(i);
                    String str = "";
                    switch (objCoa.getLevel()) {
                        case 1:
                            break;
                        case 2:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                        case 3:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                        case 4:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                        case 5:
                            str = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                            break;
                    }

                    out.println(str + "<a style='color:blue' href=\"javascript:cmdSelect('" + objCoa.getOID() + "','" + objCoa.getCode() + " - " + objCoa.getName() + "')\">" + objCoa.getCode() + " - " + objCoa.getName() + "</a><br />");
                }
            }
                        %>
                    </form>
                </td>
            </tr>
        </table>
    </body>
</html>
