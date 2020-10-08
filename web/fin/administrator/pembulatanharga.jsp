
<%-- 
    Document   : pembulatanharga
    Created on : Oct 9, 2014, 8:22:13 PM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "com.project.fms.master.*" %>
<%@ page import = "com.project.fms.session.*" %>
<%@ page import = "com.project.fms.transaction.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/check.jsp"%>


<%
            String sql = "select price_type_id, gol_10,gol10_margin,cogs from pos_price_type t left join pos_item_master m on t.item_master_id = m.item_master_id where gol_10 != 0";// limit 10";
            try {

                CONResultSet dbrs = null;
                dbrs = CONHandler.execQueryResult(sql);
                ResultSet rs = dbrs.getResultSet();
                while (rs.next()) {

                    long priceId = rs.getLong("price_type_id");
                    double gol10 = rs.getDouble("gol_10");
                    System.out.print("gol 10 "+gol10);
                    double gol1Margin = rs.getDouble("gol10_margin");
                    double cogs = rs.getDouble("cogs");
                    double tmp = gol10;
                    
                    int counter = 0;
                    while(tmp >= 1000){                        
                        tmp= tmp - 1000;
                        counter++;
                    }
                    
                    System.out.print(" >>> pembagi  "+counter);
                    
                    double sisa = 0;
                    if(tmp != 0){
                        if(tmp > 500){
                            sisa = 1000;
                        }else{
                            sisa = 500;
                        }
                    }
                    
                    double hasil = (counter * 1000) + sisa;
                    System.out.print(" >>> hasil  "+hasil);
                    System.out.println("");
                    ManualProcess.updateGol(priceId,hasil,cogs);
                    
                }
                rs.close();


            } catch (Exception e) {
            }


%>

