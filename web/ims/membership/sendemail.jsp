
<%-- 
    Document   : sendemail
    Created on : May 15, 2015, 3:47:52 PM
    Author     : Roy
--%>

<%@ page language="java"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "com.project.util.*" %>
<%@ page import = "com.project.util.mail.*" %>
<%@ page import = "com.project.util.jsp.*" %>
<%@ page import = "com.project.system.*" %>
<%@ page import = "com.project.main.db.*" %>
<%@ page import = "java.util.Date" %>
<%@ include file = "../main/javainit.jsp" %>
<%@ include file = "../main/check.jsp" %>
<%
            boolean priv = QrUserSession.isHavePriviledge(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER);
            boolean privView = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_VIEW);
            boolean privUpdate = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_UPDATE);
            boolean privAdd = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_ADD);
            boolean privDelete = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_DELETE);
            boolean privPrint = appSessUser.isPriviledged(appSessUser.getUserOID(), AppMenu.M1_MASTER_MAINTENANCE, AppMenu.M2_MASTER_MEMBER, AppMenu.PRIV_PRINT);
%>
<%
//jsp content
            long memberId = JSPRequestValue.requestLong(request, "hidden_member_id");
            int typex = JSPRequestValue.requestInt(request, "typex");
            
            String from = "oxy";
            
        String to = "roy.andika.st@gmail.com";
        String cc = req.getParameter("cc");
        String bcc = req.getParameter("bcc");
        String subject = req.getParameter("subject");
        String text = req.getParameter("text");

                                                
            /*try {
                MailSenderModif ms = new MailSenderModif();
                ms.setSMTPHost("smtp.gmail.com");
                ms.setSenderAddr("oxysystemdanaco@gmail.com");
                ms.setSender("oxysystemdanaco@gmail.com");
                ms.setReceiver("roy.andika.st@gmail.com");
                ms.setSubject("konfirmasi pendaftaran");
                ms.setMessage("testing member");
                ms.sendMail();

            } catch (Exception e) {
                System.out.println("exception email : " + e.toString());
            }

            try {
                MailSenderModif ms = new MailSenderModif();
                ms.setSMTPHost("smtp.gmail.com");
                ms.setSenderAddr("oxysystemdanaco@gmail.com");
                ms.setSender("coco");
                ms.setReceiver("ekads3007@gmail.com");
                ms.setSubject("Pendaftaran Baru");
                ms.setMessage("testing member");
                ms.sendMail();
                out.println("in success sending email");
            } catch (Exception e) {
                System.out.println("exception email : " + e.toString());
            }
 */
            
            
                    
                    
                    

%>