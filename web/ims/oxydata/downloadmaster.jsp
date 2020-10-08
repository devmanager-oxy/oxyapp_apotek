<%@ page language = "java" %>
<%@ page import = "com.project.ccs.sql.*" %>
<%
            String strQuery = "";
            String command = request.getParameter("command");
            String fieldNames = request.getParameter("fieldnames");
            String start = request.getParameter("start_limit");
            String recordToGet = request.getParameter("record_limit");

            System.out.println("command : " + command);
            System.out.println("fieldNames : " + fieldNames);
            System.out.println("start : " + start);
            System.out.println("recordToGet : " + recordToGet);

            try {
                if (Integer.parseInt(command) == 11) {
                    String sql = "select * from logs where table_name in('customer','sysuser','pos_item_master'," +
                            "'pos_price_type','pos_item_group','pos_unit'," +
                            "'member','bank','pos_promotion','pos_promotion_item','pos_promotion_location','merchant','currency') " +
                            " and " + fieldNames + "=0 order by date asc limit " + start + " , " + recordToGet;

                    strQuery = SQLGeneral.createMasterUpdate(sql);
                    System.out.println("----------- download sukses-------------");
                }
            } catch (Exception e) {                
                System.out.println("----------- download gagal -------------");
            }
%>
<%=strQuery%>