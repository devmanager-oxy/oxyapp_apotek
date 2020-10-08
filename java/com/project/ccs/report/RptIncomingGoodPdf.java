/*
 * RptIncomingGoodPdf.java
 *
 * Created on January 17, 2009, 9:58 AM
 */

package com.project.ccs.report;


import java.util.*;
//import java.sql.*;
import java.awt.Color;
import java.awt.Point;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;

import javax.servlet.*;
import javax.servlet.http.*;

import com.lowagie.text.*;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.html.HtmlWriter;

import com.project.util.*;
import com.project.main.entity.*;
import com.project.main.db.*;
import com.project.ccs.postransaction.purchase.*;
import com.project.ccs.postransaction.request.*;
import com.project.ccs.report.*;

public class RptIncomingGoodPdf extends HttpServlet {
   
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
        System.out.println("===| RptIncomingGoodPdf |===");
        //long oidEmployee = FRMQueryString.requestLong(request, "oid");
        
        SessIncomingGood iGood = new SessIncomingGood(); 
        try{
            HttpSession session = request.getSession();
            iGood = (SessIncomingGood)session.getValue("INCOMING_TITTLE");
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        Vector vectorList = new Vector();
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("INCOMING_DETAIL");
        }catch(Exception e){
            System.out.println(e.toString());
        }

        
        //NumberSpeller numSpeller = new NumberSpeller();
        
        Color border = new Color(0x00, 0x00, 0x00);
        
        // setting some fonts in the color chosen by the user
        Font fontHeaderBig = new Font(Font.HELVETICA, 10, Font.BOLD, border);
        Font fontHeader = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font fontContent = new Font(Font.HELVETICA, 8, Font.BOLD, border);
        Font tableContent = new Font(Font.HELVETICA, 8, Font.NORMAL, border);
        Font fontSpellCharge = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalic = new Font(Font.HELVETICA, 8, Font.BOLDITALIC, border);
        Font fontItalicBottom = new Font(Font.HELVETICA, 8, Font.ITALIC, border);
        Font fontUnderline = new  Font(Font.HELVETICA, 8, Font.UNDERLINE, border);
        
        Color bgColor = new Color(240,240,240);
        
        Color blackColor = new Color(0,0,0);
        
        Color putih = new Color(250,250,250);
                
        Document document = new Document(PageSize.A4, 30, 30, 50, 50);
        //Document document = new Document(PageSize.A4.rotate(), 10, 10, 30, 30);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        int start = 0;
        
        try{
             // step2.2: creating an instance of the writer
            PdfWriter.getInstance(document, baos);

            // step 3.1: adding some metadata to the document
            document.addSubject("This is a subject.");
            document.addSubject("This is a subject two.");    
            
            //Header 
            HeaderFooter header = new HeaderFooter(new Phrase("COST CONTROL SYSTEM"), false);
            header.setAlignment(Element.ALIGN_LEFT);
            header.setBorder(Rectangle.BOTTOM);
            header.setBorderColor(blackColor);
            document.setHeader(header);
            
            // step 3.4: opening the document
            document.open();
            
           
    //PO RETUR
            
            System.out.println("===| laporan masuk |===");

            int poHeaderTop[] = {25,5,45,12,25,5,40};
            Table poTable = new Table(7);
            poTable.setWidth(100);
            poTable.setWidths(poHeaderTop);
            poTable.setBorderColor(new Color(255,255,255));
            poTable.setBorderWidth(0);
            poTable.setAlignment(1);
            poTable.setCellpadding(0);
            poTable.setCellspacing(1);

             //0
            Cell titleCellTop = new Cell(new Chunk("Incoming Goods", fontContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setColspan(7);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setColspan(7);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            
            if(iGood.getOidGoods()!=0){
            
                    //PoNumber
                    titleCellTop = new Cell(new Chunk("PoNumber", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    poTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk(":", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    poTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk(iGood.getPoNumber(), tableContent));
                    titleCellTop.setColspan(5);
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    poTable.addCell(titleCellTop);

                    //PoDate
                    titleCellTop = new Cell(new Chunk("PO Date", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    poTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk(":", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    poTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk(JSPFormater.formatDate(iGood.getPoDate(), "dd/MM/yyyy"), tableContent));
                    titleCellTop.setColspan(5);
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    poTable.addCell(titleCellTop);
                    
            }        
            

            //Vendor
            titleCellTop = new Cell(new Chunk("Vendor", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(iGood.getVendor(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
   
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("Receive In", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(iGood.getReceiveIn(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            //Address
            titleCellTop = new Cell(new Chunk("Address", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(iGood.getAddress(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("DOC Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(iGood.getDocNumber(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            //DO Number
            titleCellTop = new Cell(new Chunk("DO Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(iGood.getDoNumber(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            //Invoice Number
            titleCellTop = new Cell(new Chunk("Invoice Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(iGood.getInvoiceNumber(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            //Date
            titleCellTop = new Cell(new Chunk("Date", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(JSPFormater.formatDate((iGood.getDate()==null) ? new Date() : iGood.getDate(), "dd/MM/yyyy"), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("Applay VAT", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
                String ApplayVat = "";
                if(iGood.getApplayVat()==0){
                    ApplayVat = "No";
                }else{
                    ApplayVat = "Yes";
                }
            
            titleCellTop = new Cell(new Chunk(ApplayVat, tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            //Payment Type
            titleCellTop = new Cell(new Chunk("Payment Type", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(iGood.getPaymentType(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("Term Of Payment", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(JSPFormater.formatDate((iGood.getTop()==null) ? new Date() : iGood.getTop(), "dd/MM/yyyy"), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);
            
            //Notes
            titleCellTop = new Cell(new Chunk("Notes", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(iGood.getNotes(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            poTable.addCell(titleCellTop);

            document.add(poTable);
            
 //Listnya
                 
        if(vectorList!=null && vectorList.size()>0){
            
            System.out.println("===| list tidak kosong |===");
                
                    //membuat table 
                    int prHeaderTop[] = { 2,10,10,10,10,10,10,10 };
                    Table prTable = new Table(8);
                    prTable.setWidth(100);
                    prTable.setWidths(prHeaderTop);
                    prTable.setBorderColor(new Color(255,255,255));
                    prTable.setBorderWidth(1);
                    prTable.setAlignment(1);
                    prTable.setCellpadding(0);
                    prTable.setCellspacing(1);
                    
                    
                    //space antar table
                    Cell titlePrCellTop = new Cell(new Chunk(" ", tableContent));
                    titlePrCellTop.setColspan(8);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(new Color(255,255,255));
                    prTable.addCell(titlePrCellTop);
                    
                    //No
                    titlePrCellTop = new Cell(new Chunk("No", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Group/Category/Code - Name", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Price", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Qty", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Discount", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Total", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Unit", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Expired Date", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    
                //value-valuenya
                for(int i=0;i<vectorList.size();i++){
                    SessIncomingGoodL iGoodL = (SessIncomingGoodL)vectorList.get(i);
                   
                    int n =(i+1);
                    
                    titlePrCellTop = new Cell(new Chunk(String.valueOf(n), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(iGoodL.getGroup(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGoodL.getPrice(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGoodL.getQty(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGoodL.getDiscount(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGoodL.getTotal(), "#,###.##"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(iGoodL.getUnit(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatDate(iGoodL.getExpiredDate(), "dd/MM/yyyy"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                }
                
                    document.add(prTable);
            }
            
            
    //Subnya

            int approvalHeaderTop[] = {30,10,10,7,10,10,10,10};
            Table approvalTable = new Table(8);
            approvalTable.setWidth(100);
            approvalTable.setWidths(approvalHeaderTop);
            approvalTable.setBorderColor(new Color(255,255,255));
            approvalTable.setBorderWidth(0);
            approvalTable.setAlignment(1);
            approvalTable.setCellpadding(0);
            approvalTable.setCellspacing(1);

             //0
            Cell spaceCellTop = new Cell(new Chunk(" ", fontContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setColspan(8);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setColspan(8);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            //Subtotal
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("SubTotal", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGood.getSubTotal(), "#,###.##"), tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            //Discount
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("Discount", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk(iGood.getDiscount1()+" % ", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGood.getDiscount2(), "#,###.##"), tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            //Vat
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("VAT", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk(iGood.getVat1()+" % ", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGood.getVat2(), "#,###.##"), tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            //Grand Total
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("Grand Total", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(iGood.getGrandTotal(), "#,###.##"), tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            document.add(approvalTable);
            
            
   //Sign

            int signHeaderTop[] = {10,10,10,7,10,10,10};
            Table signTable = new Table(7);
            signTable.setWidth(100);
            signTable.setWidths(signHeaderTop);
            signTable.setBorderColor(new Color(255,255,255));
            signTable.setBorderWidth(0);
            signTable.setAlignment(1);
            signTable.setCellpadding(0);
            signTable.setCellspacing(1);

             //0
            Cell signCellTop = new Cell(new Chunk(" ", fontContent));
            signCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCellTop.setColspan(7);
            signCellTop.setBorderColor(new Color(255,255,255));
            signTable.addCell(signCellTop);

            signCellTop = new Cell(new Chunk(" ", tableContent));
            signCellTop.setColspan(7);
            signCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCellTop.setBorderColor(new Color(255,255,255));
            signTable.addCell(signCellTop);
            
            signCellTop = new Cell(new Chunk(" ", fontContent));
            signCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCellTop.setColspan(7);
            signCellTop.setBorderColor(new Color(255,255,255));
            signTable.addCell(signCellTop);

            document.add(signTable);  
            
         
  //Approval and Prepared By

            int approval1HeaderTop[] = {10,10,10,7,10,10,10};
            Table approva1lTable = new Table(7);
            approva1lTable.setWidth(100);
            approva1lTable.setWidths(approval1HeaderTop);
            approva1lTable.setBorderColor(new Color(255,255,255));
            approva1lTable.setBorderWidth(0);
            approva1lTable.setAlignment(1);
            approva1lTable.setCellpadding(0);
            approva1lTable.setCellspacing(1);

             //0
            Cell spaceCell1Top = new Cell(new Chunk(" ", fontContent));
            spaceCell1Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCell1Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCell1Top.setColspan(7);
            spaceCell1Top.setBorderColor(new Color(255,255,255));
            approva1lTable.addCell(spaceCell1Top);
            
            spaceCell1Top = new Cell(new Chunk(" ", tableContent));
            spaceCell1Top.setColspan(7);
            spaceCell1Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCell1Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCell1Top.setBorderColor(new Color(255,255,255));
            approva1lTable.addCell(spaceCell1Top);

            spaceCell1Top = new Cell(new Chunk(" ", tableContent));
            spaceCell1Top.setColspan(7);
            spaceCell1Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCell1Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCell1Top.setBorderColor(new Color(255,255,255));
            approva1lTable.addCell(spaceCell1Top);

            //Prepared By and Approval BY
            spaceCell1Top = new Cell(new Chunk("Prepared By", tableContent));
            spaceCell1Top.setColspan(3);
            spaceCell1Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCell1Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCell1Top.setBorderColor(new Color(255,255,255));
            approva1lTable.addCell(spaceCell1Top);

            spaceCell1Top = new Cell(new Chunk("", tableContent));
            spaceCell1Top.setHorizontalAlignment(Element.ALIGN_CENTER);
            spaceCell1Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCell1Top.setBorderColor(new Color(255,255,255));
            approva1lTable.addCell(spaceCell1Top);

            spaceCell1Top = new Cell(new Chunk("Approval By", tableContent));
            spaceCell1Top.setColspan(3);
            spaceCell1Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCell1Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCell1Top.setBorderColor(new Color(255,255,255));
            approva1lTable.addCell(spaceCell1Top);

            document.add(approva1lTable);
            
            
   //Sign

            int sign1HeaderTop[] = {10,10,10,7,10,10,10};
            Table sign1Table = new Table(7);
            sign1Table.setWidth(100);
            sign1Table.setWidths(sign1HeaderTop);
            sign1Table.setBorderColor(new Color(255,255,255));
            sign1Table.setBorderWidth(0);
            sign1Table.setAlignment(1);
            sign1Table.setCellpadding(0);
            sign1Table.setCellspacing(1);

             //0
            Cell signCell2Top = new Cell(new Chunk(" ", fontContent));
            signCell2Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCell2Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCell2Top.setColspan(7);
            signCell2Top.setBorderColor(new Color(255,255,255));
            sign1Table.addCell(signCell2Top);

            signCell2Top = new Cell(new Chunk(" ", tableContent));
            signCell2Top.setColspan(7);
            signCell2Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCell2Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCell2Top.setBorderColor(new Color(255,255,255));
            sign1Table.addCell(signCell2Top);
            
            signCell2Top = new Cell(new Chunk(" ", fontContent));
            signCell2Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCell2Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCell2Top.setColspan(7);
            signCell2Top.setBorderColor(new Color(255,255,255));
            sign1Table.addCell(signCell2Top);

 //Linenya
            signCell2Top = new Cell(new Chunk("", tableContent));
            signCell2Top.setColspan(3);
            signCell2Top.setBorder(Rectangle.BOTTOM);
            signCell2Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCell2Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCell2Top.setBorderColor(blackColor);
            sign1Table.addCell(signCell2Top);

            signCell2Top = new Cell(new Chunk("", tableContent));
            signCell2Top.setHorizontalAlignment(Element.ALIGN_CENTER);
            signCell2Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCell2Top.setBorderColor(new Color(255,255,255));
            sign1Table.addCell(signCell2Top);

            signCell2Top = new Cell(new Chunk("", tableContent));
            signCell2Top.setColspan(3);
            signCell2Top.setBorder(Rectangle.BOTTOM);
            signCell2Top.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCell2Top.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCell2Top.setBorderColor(blackColor);
            sign1Table.addCell(signCell2Top);

            document.add(sign1Table);  
            
            
             
        }catch(Exception e){}
        
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
