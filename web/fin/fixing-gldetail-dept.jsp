<%@ page language="java"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.project.main.db.*"%>
<%@ page import="com.project.util.*"%>
<%@ page import="com.project.util.jsp.*"%>
<%@ page import="com.project.fms.transaction.*"%>
<%@ page import="com.project.fms.master.*"%>
<%@ page import="com.project.main.db.*"%>
<%

int iCommand = JSPRequestValue.requestCommand(request);
long periodId = JSPRequestValue.requestLong(request, "period_id");

if (iCommand == JSPCommand.SUBMIT) {

    out.println("start --- processing department on gl detail");

    Vector vGl = DbGl.list(0, 0, DbGl.colNames[DbGl.COL_PERIOD_ID] + "=" + periodId, "");
    
    if (vGl != null && vGl.size() > 0) {
        for (int n = 0; n < vGl.size(); n++) {
            Gl objGl = (Gl) vGl.get(n);
            String where = DbGlDetail.colNames[DbGlDetail.COL_DEPARTMENT_ID] + "!=0 AND " +
                    DbGlDetail.colNames[DbGlDetail.COL_GL_ID] + "=" + objGl.getOID();
            
            Vector v = DbGlDetail.list(0, 0, where, "");
            
            if (v != null && v.size() > 0) {
                out.println("<br>v.size() " + v.size());
                for (int i = 0; i < v.size(); i++) {
                    GlDetail gld = (GlDetail) v.get(i);
                    gld = DbGlDetail.setOrganizationLevel(gld);
                    try {
                        long oid = DbGlDetail.updateExc(gld);
                        out.println("<br>----> processing idx :" + i + ", " + gld.getOID() + " ====== success");
                    } catch (Exception e) {
                        out.println("<br>----> processing idx :" + i + ", " + gld.getOID() + " ====== failed");
                    }
                }
            }
        }
    }

    out.println("<br>end --- processing gl detail");
}

%>

<html>
<head>
<title>Fixing GL Detail Department</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<script language="JavaScript">
function cmdFix(){
	document.form1.command.value="<%=JSPCommand.SUBMIT%>";
	document.form1.action="fixing-gldetail-dept.jsp";
	document.form1.submit();
}

</script>
<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="">
  <p> 
    <input type="hidden" name="command">
	<%
	Vector periods = DbPeriode.list(0,0, "", DbPeriode.colNames[DbPeriode.COL_START_DATE]);
	%>
    <select name="period_id">
		<%for(int i=0; i<periods.size(); i++){
		Periode per = (Periode)periods.get(i);
		%>
      <option value="<%=per.getOID()%>" <%if(periodId==per.getOID()){%>selected<%}%>><%=per.getName()%></option>
	  <%}%>
    </select>
    <input type="button" name="Button" value="Update Dept Level" onClick="javascript:cmdFix()">
  </p>
  </form>
</body>
</html>
