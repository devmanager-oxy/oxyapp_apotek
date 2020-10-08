<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "java.io.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.util.encript.*" %>
<%@ page import = "com.project.payroll.*" %>
<%@ page import = "com.project.ccs.posmaster.*" %>
<%@ page import = "com.project.ccs.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%//@ include file = "../main/javainit.jsp" %>
<% int  appObjCode = 1;// AppObjInfo.composeObjCode(AppObjInfo.--, AppObjInfo.--, AppObjInfo.--); %>
<%//@ include file = "../main/checksl.jsp" %>
<%//@page contentType="text/html" pageEncoding="UTF-8"%>
<%
int iJSPCommand = JSPRequestValue.requestCommand(request);
int start = JSPRequestValue.requestInt(request, "start");
int prevJSPCommand = JSPRequestValue.requestInt(request, "prev_command");
long companyId = JSPRequestValue.requestLong(request, "company_id");
long location_id =JSPRequestValue.requestLong(request, "location_id");
%>
        <%
        String sql = "select * from logs  where sync_status=0";// and location_id=" + location_id;//periode_id="+oidPeriode;
        // String sql = "select * from logs  where sync_status=0";// and location_id=" + location_id;//periode_id="+oidPeriode;
        System.out.println("sql : "+sql);
        
        CONResultSet crs = null;
        Vector temp = new Vector();
        try{
            crs = CONHandler.execQueryResult(sql);
            ResultSet rs = crs.getResultSet();
            while(rs.next()){
            	Vector xx = new Vector();
                
                String table = rs.getString("table_name");                
                String str = rs.getString("query_string");    
                long oid = rs.getLong("log_id");    
                
                xx.add(table);	            
                xx.add(str);
                xx.add(""+oid);
                	
                temp.add(xx);
            }
        }
        catch(Exception e){
            System.out.println(e.toString());
        }
        finally{
            CONResultSet.close(crs);
        }
        
        

        if(temp!=null && temp.size()>0){
           
          // System.out.println("--Total data : "+temp.size()); 
            
           for (int i=0; i<temp.size(); i++) {
                Vector xTemp = (Vector)temp.get(i);  	   	

               String encChr = TextEncriptor.getEncriptType();
                String table  = (String)xTemp.get(0);	
               String query  = (String)xTemp.get(1);
             if(query==null || query.length()==0){
                   
               }
               else{ %>
               <%=(TextEncriptor.encriptText(encChr, "" + table) + "(*)" + TextEncriptor.encriptText(encChr, "" + query) + "|" + encChr)%>
               <%     
               }
          }
        }
        %>
