
<%@ page language = "java" %>
<%@ page import = "java.util.*" %>
<%@ page import = "com.project.printer.DbDocPrinter" %>
<%@ page import = "com.project.printer.DocPrinter" %>
<%@ page import = "com.project.util.*" %>
<%@ include file="../main/javainit.jsp"%>
<%@ include file="../main/checksl.jsp"%>
<%
            String strQuery = "";
            String command = request.getParameter("command");
            String hostPrinter = request.getParameter("host_printer");            
            long docId = 0;
            String docCode = "";
            DocPrinter docPrinter = new DocPrinter();                       
            
            try {
                if (Integer.parseInt(command) == JSPCommand.PRINT) {                    
                    Vector docList = DbDocPrinter.list(0, 1,"", "");                    
                    
                    if (docList.size() > 0) {
                        docPrinter = (DocPrinter) docList.get(0);
                        docId = docPrinter.getDocId();                        
                        docCode = docPrinter.getDocCode();
                        DbDocPrinter.deleteExc(docPrinter.getOID());
                    }
                }
            } catch (Exception e) {
                System.out.println("err" + e.toString());
            }
            
            if(docCode.compareTo("SURATPESANAN") == 0){
%> 
<%@ include file="../simprop/docprinter/suratpesanan.jsp"%>
<%}else{%>
<%@ include file="../simprop/docprinter/kwitansi.jsp"%>
<%}%>

    

