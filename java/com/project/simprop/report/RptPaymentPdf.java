/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.simprop.report;

import com.lowagie.text.*;
import com.lowagie.text.Image;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Document;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.io.ByteArrayOutputStream;
import java.util.Vector;
import java.util.Date;
import java.net.MalformedURLException;
import java.net.URL;

import com.lowagie.text.Font;
import com.project.util.jsp.*;
import com.project.fms.master.*;
import com.project.fms.journal.*;
import com.project.fms.transaction.*;
import com.project.payroll.*;
import com.project.util.*;
import com.project.system.*;

import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.simprop.property.DbSalesData;
import com.project.simprop.session.RptCustomer;
import com.project.simprop.session.RptPayment;

/**
 *
 * @author Roy Andika
 */
public class RptPaymentPdf extends HttpServlet {
    
    /** Initializes the servlet.
     */
    public void init(ServletConfig config) throws ServletException {
        super.init(config);

    }

    /** Destroys the servlet.
     */
    public void destroy() {

    }

    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        System.out.println("===| RptIncomingGoodsPdf |===");
        int lang = 0;

        Vector result = new Vector();

        try {
            HttpSession session = request.getSession();
            result = (Vector) session.getValue("RPT_PAYMENT");
            lang = JSPRequestValue.requestInt(request, "lang"); 
        } catch (Exception e) {
            System.out.println(e.toString());
        }
        
        Company cmp = new Company();
        try{
            Vector listCompany = DbCompany.list(0,0, "", "");
            if(listCompany!=null && listCompany.size()>0){
                cmp = (Company)listCompany.get(0);
            }
        }catch(Exception ext){
            System.out.println(ext.toString());
        }
        
        String title = "";
        if(lang == 0){
            title = "LAPORAN PEMBAYARAN";
        }else{
            title = "PAYMENT REPORT";
        }

        Color border = new Color(0x00, 0x00, 0x00);

        // setting some fonts in the color chosen by the user
        Font fontHeaderBig = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font fontHeader = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontContent = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontTitle = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font tableContent = new Font(Font.HELVETICA, 8, Font.NORMAL, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalic = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalicBottom = new Font(Font.HELVETICA, 8, Font.ITALIC, border);
        Font fontUnderline = new Font(Font.HELVETICA, 8, Font.UNDERLINE, border);

        Color bgColor = new Color(240, 240, 240);

        Color blackColor = new Color(0, 0, 0);

        Color putih = new Color(250, 250, 250);

        Document document = new Document(PageSize.A4, 30, 30, 50, 50);
        //Document document = new Document(PageSize.A4.rotate(), 10, 10, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int start = 0;

        try {
            // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");

            document.open();

            //for header =========================================================== 
            int titleHeader[] = {10, 10, 10, 7, 10, 10, 10};
            Table titleTable = new Table(7);
            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setBorderColor(new Color(255, 255, 255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);

            Cell titleCellHeader = new Cell(new Chunk(""+cmp.getName().toUpperCase()+"", fontTitle ));
            titleCellHeader.setColspan(7);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255,255,255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk(title, fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk("", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255, 255, 255));
            titleTable.addCell(titleCellHeader);
            
            document.add(titleTable); 

            if (result != null && result.size() > 0) {

                //membuat table 
                int poHeaderTop[] = {3, 7, 15, 15, 15, 15, 10, 10, 10, 10, 10};
                
                Table prTable = new Table(11);
                prTable.setWidth(100);
                prTable.setWidths(poHeaderTop);
                prTable.setBorderColor(blackColor);
                prTable.setBorderWidth(1);
                prTable.setAlignment(1);
                prTable.setCellpadding(0);
                prTable.setCellspacing(1);

                //space antar table
                Cell titlePrCellTop = new Cell(new Chunk(" ", tableContent));

                titlePrCellTop = new Cell(new Chunk("No", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);
                
                

                titlePrCellTop = new Cell(new Chunk("Sales Person", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Customer", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);


                titlePrCellTop = new Cell(new Chunk("Lot", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk("Inv Date", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Inv No", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Inv Desc", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Inv Amount(Rp)", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                titlePrCellTop = new Cell(new Chunk("Payment Date", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk("Payment #", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);
                
                titlePrCellTop = new Cell(new Chunk("Payment Amount(Rp)", fontHeader));
                titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titlePrCellTop.setBorderColor(blackColor);
                titlePrCellTop.setBackgroundColor(bgColor);
                prTable.addCell(titlePrCellTop);

                double totInv = 0;
                double totPemb = 0;
                long stiOid = 0;
                int no = 1;

                //value-valuenya
                for (int i = 0; i < result.size(); i++) {
                    
                    RptPayment rptPay = (RptPayment) result.get(i);        
                    totPemb = totPemb + rptPay.getPaymentAmount();
                    
                    
                    if(stiOid == 0 || rptPay.getInvoiceId() != stiOid){ 
                        stiOid = rptPay.getInvoiceId();
                        totInv = totInv + rptPay.getInvAmount();
                        
                        titlePrCellTop = new Cell(new Chunk("" +no, tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);
                        no++;

                        titlePrCellTop = new Cell(new Chunk(rptPay.getSalesPerson(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("" + rptPay.getCustomer(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(rptPay.getProperty()+","+rptPay.getTower()+","+rptPay.getFloor()+","+rptPay.getLot(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatDate(rptPay.getInvDate(), "dd MMMM yyyy"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(rptPay.getInvNo(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(rptPay.getInvDesc(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(rptPay.getInvAmount(), "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatDate(rptPay.getPaymentDate(), "dd MMMM yyyy"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(rptPay.getPaymentNo(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(rptPay.getPaymentAmount(), "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);                        
                        
                    }else{
                        
                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatDate(rptPay.getPaymentDate(), "dd MMMM yyyy"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(rptPay.getPaymentNo(), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(rptPay.getPaymentAmount(), "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);        
                        
                    }    

                }
                
                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("TOTAL", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(totInv, "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk("TOTAL", tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);

                        titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(totPemb, "#,###.##"), tableContent));
                        titlePrCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
                        titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                        titlePrCellTop.setBorderColor(blackColor);
                        prTable.addCell(titlePrCellTop);        

                
                document.add(prTable);
            }


        } catch (Exception e) {

            System.out.println(e.toString());

        }

        document.close();

        System.out.println("print==============");
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }

    /** Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        processRequest(request, response);
    }

    /** Returns a short description of the servlet.
     */
    public String getServletInfo() {
        return "Short description";
    }


}
