/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.general;

import javax.mail.*;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

/**
 *
 * @author Roy
 */
public class SendMailServlet extends HttpServlet {

    private String smtpHost;

//initialize this servlet to get SMTP Host Name to use in sending message
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        smtpHost = config.getInitParameter("smtpHost");
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        /*String from = req.getParameter("oxy");
        String to = req.getParameter("to");
        String cc = req.getParameter("cc");
        String bcc = req.getParameter("bcc");
        String subject = req.getParameter("subject");
        String text = req.getParameter("text");*/
        
        String from = "oxysystemdanaco@gmail.com";
        String to = "roy.andika.st@gmail.com";
        //String cc = "ekads3007@gmail.com";
        //String bcc = "ekads3007@gmail.com";
        String subject ="test member";
        String text ="test member";

        String status;
        try {
//create java mail session
            Properties prop = System.getProperties();
            prop.put("mail.smtp.host", smtpHost);
            Session session = Session.getInstance(prop, null);

//construct the message
            MimeMessage message = new MimeMessage(session);

//set the from adress
            Address fromAddress = new InternetAddress(from);
            message.setFrom(fromAddress);

//parse and set the recipient
            Address[] toAddress = InternetAddress.parse(to);
            message.setRecipients(Message.RecipientType.TO, toAddress);
            Address[] ccAddress = InternetAddress.parse(to);
            message.setRecipients(Message.RecipientType.CC, ccAddress);
            Address[] bccAddress = InternetAddress.parse(to);
            message.setRecipients(Message.RecipientType.BCC, bccAddress);

//set The Subject and Text
            message.setSubject(subject);
            message.setText(text);

//begin send Message
            Transport.send(message);
            status = "Your Message has sent";


        } catch (AddressException aex) {
            status = "There was an error when parsing the address";
        } catch (SendFailedException sfe) {
            status = "There was an error when sending the Message";
        } catch (MessagingException me) {
            status = "There was unexpected error";
        }

//print out status in display
        res.setContentType("text/html");
        PrintWriter writer = res.getWriter();
        writer.println("<html><head><title>Status</title></head>");
        writer.println("<body><p>" + status + "</body></html>");
        writer.close();
    }
}
