<%@ page language = "java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.project.main.db.*" %>
<%@ page import="com.project.util.*" %>
<%@ page import="com.project.util.jsp.*" %>
<%@ page import="com.project.general.*" %>
<%
String queryInsert = JSPRequestValue.requestString(request, "qr");
String tableName = JSPRequestValue.requestString(request, "tblname");
long logId = JSPRequestValue.requestLong(request, "logid");

System.out.println("-------- ini halaman diseberang - qr : "+queryInsert);

int result = 0;

try {

    //if (CONLogger.notInExceptionTable(tableName)) {
    if(queryInsert!=null && queryInsert.length()>0 && tableName!=null && tableName.length()>0){
        Company comp = DbCompany.getCompany();
        Date dt = new Date();
        
        queryInsert = queryInsert.replace("XX", "\\'");
        queryInsert = queryInsert.replace("YY", "\\'\\'");
        
        System.out.println("-------- ini halaman diseberang - qr perbaikan : "+queryInsert);
        
        long log_id = logId;
        
        if(logId!=0){
            //String sql = "insert into logs (log_id, query_string, company_id, table_name, period_middle_date)" +
            String sql = "insert into logs_test (log_id, query_string, company_id, table_name, period_middle_date)" +
                    " values (" + log_id + ", '" + queryInsert + "'," + comp.getOID() + ",'" +
                    tableName + "','" + JSPFormater.formatDate(dt, "yyyy-MM-dd") + "')";

            try{
                CONHandler.execUpdate(sql);
            }
            catch(Exception ex){
                result = -1;
                System.out.println(ex.toString());                
            }
        }
    }
    else{
        result = -1;
    }

} catch (Exception e) {
    System.out.println(e.toString());
}

System.out.println("-------- ini halaman diseberang - result : "+result);

%>
<%=result%>