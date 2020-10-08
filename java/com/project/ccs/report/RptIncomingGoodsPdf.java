/*
 * RptIncomingGoods.java
 *
 * Created on January 18, 2009, 9:57 PM
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
import com.project.general.*;

/**
 *
 * @author  offices
 */
public class RptIncomingGoodsPdf extends HttpServlet {
   
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
        //long oidEmployee = FRMQueryString.requestLong(request, "oid");
        
        SessIncomingGoods ig = new SessIncomingGoods(); 
        try{
            HttpSession session = request.getSession();
           ig = (SessIncomingGoods)session.getValue("PURCHASE_TITTLE");
        }catch(Exception e){
            System.out.println(e.toString());
        }
        
        Vector vectorList = new Vector();
        try{
            HttpSession session = request.getSession();
            vectorList = (Vector)session.getValue("PURCHASE_DETAIL");
        }catch(Exception e){
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

        
        //NumberSpeller numSpeller = new NumberSpeller();
        
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
            /*
            HeaderFooter header = new HeaderFooter(new Phrase(""+cmp.getName()+"\n"+cmp.getAddress()+"\nIncoming Goods"+""), false);
            header.setAlignment(Element.ALIGN_LEFT);
            header.setBorder(Rectangle.BOTTOM);
            header.setBorderColor(blackColor);
            document.setHeader(header);
             */
            
            // step 3.4: opening the document
            document.open();
                       
    
    //for header =========================================================== 
            int titleHeader[] = {10,10,10,7,10,10,10};
            Table titleTable = new Table(7);
            titleTable.setWidth(100);
            titleTable.setWidths(titleHeader);
            titleTable.setBorderColor(new Color(255,255,255));
            titleTable.setBorderWidth(0);
            titleTable.setAlignment(1);
            titleTable.setCellpadding(0);
            titleTable.setCellspacing(1);
            
            
            Cell titleCellHeader = new Cell(new Chunk("INCOMING GOODS", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255,255,255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+cmp.getName().toUpperCase()+"", fontContent ));
            titleCellHeader.setColspan(7);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255,255,255));
            titleTable.addCell(titleCellHeader);
            
            titleCellHeader = new Cell(new Chunk(""+cmp.getAddress()+"", tableContent));
            titleCellHeader.setColspan(7);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(new Color(255,255,255));
            titleTable.addCell(titleCellHeader);

         //Linenya
            titleCellHeader = new Cell(new Chunk("", tableContent));
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorder(Rectangle.BOTTOM);
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setBorderColor(blackColor);
            titleTable.addCell(titleCellHeader);
            
            document.add(titleTable); 
            
  //==========================end================================
            
            

            int purchaseHeaderTop[] = {15,10,25,10,17,10,15};
            Table purchaseTable = new Table(7);
            purchaseTable.setWidth(100);
            purchaseTable.setWidths(purchaseHeaderTop);
            purchaseTable.setBorderColor(new Color(255,255,255));
            purchaseTable.setBorderWidth(0);
            purchaseTable.setAlignment(1);
            purchaseTable.setCellpadding(0);
            purchaseTable.setCellspacing(1);
            
            Cell titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setColspan(7);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            
            if(ig.getOidGoods()!=0){

                    // PO Number
                    titleCellTop = new Cell(new Chunk("PO Number", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    purchaseTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk(":", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    purchaseTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk((ig.getPoNumber()==null) ? "" : ig.getPoNumber(), tableContent));
                    titleCellTop.setColspan(5);
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    purchaseTable.addCell(titleCellTop);

                    //PO Date
                    titleCellTop = new Cell(new Chunk("PO Date", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    purchaseTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk(":", tableContent));
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    purchaseTable.addCell(titleCellTop);

                    titleCellTop = new Cell(new Chunk(JSPFormater.formatDate((ig.getDate()==null) ? new Date() : ig.getDate(), "dd/MM/yyy"), tableContent));
                    titleCellTop.setColspan(5);
                    titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titleCellTop.setBorderColor(new Color(255,255,255));
                    purchaseTable.addCell(titleCellTop);
            
            }
            
            //Vendor
            titleCellTop = new Cell(new Chunk("Vendor", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk((ig.getVendor()==null) ? "" : ig.getVendor(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            //Space Table
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("Receive In", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk((ig.getReceiveIn()==null) ? "" : ig.getReceiveIn(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            
            //address
            titleCellTop = new Cell(new Chunk("Address", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk((ig.getAddress()==null) ? "" : ig.getAddress(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
           
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
                                    
            titleCellTop = new Cell(new Chunk("Doc.Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk((ig.getDocNumber()==null) ? "" : ig.getDocNumber(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            
            //DO Number
            titleCellTop = new Cell(new Chunk("DO Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk((ig.getDoNumber()==null) ? "" : ig.getDoNumber(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            
            //Invoice Number
            titleCellTop = new Cell(new Chunk("Invoice Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk((ig.getInvoiceNumber()==null) ? "" : ig.getInvoiceNumber(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
           
            //Date 
            titleCellTop = new Cell(new Chunk("Date", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(JSPFormater.formatDate((ig.getDate()==null) ? new Date() : ig.getDate(), "dd/MM/yyy"), tableContent));
            //titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            if(ig.getApplayVat()==0){
                titleCellTop = new Cell(new Chunk("", tableContent));
                titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellTop.setBorderColor(new Color(255,255,255));
                purchaseTable.addCell(titleCellTop);
                
                titleCellTop = new Cell(new Chunk("", tableContent));
                titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellTop.setBorderColor(new Color(255,255,255));
                purchaseTable.addCell(titleCellTop);
            }else{
                titleCellTop = new Cell(new Chunk("Applay VAT", tableContent));
                titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellTop.setBorderColor(new Color(255,255,255));
                purchaseTable.addCell(titleCellTop);
                
                titleCellTop = new Cell(new Chunk(":", tableContent));
                titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                titleCellTop.setBorderColor(new Color(255,255,255));
                purchaseTable.addCell(titleCellTop);
            }
            String ApplayVat = "";
                if(ig.getApplayVat()==0){
                    ApplayVat = "";
                }else{
                    ApplayVat = "Yes";
                    
                }
            titleCellTop = new Cell(new Chunk(ApplayVat, tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            
            
            //Payment
            titleCellTop = new Cell(new Chunk("Payment", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(ig.getPaymentType(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("Term of Payment", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(JSPFormater.formatDate(ig.getTermOfPayment(), "dd/MM/yyyy"), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
                        
            //Notes
            titleCellTop = new Cell(new Chunk("Notes", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk((ig.getNotes()==null)?"":ig.getNotes(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
                        
            document.add(purchaseTable);
            
            
 //Listnya
                 
        if(vectorList!=null && vectorList.size()>0){
                
                    //membuat table 
                    int poHeaderTop[] = { 30,10,10,10,15,15 ,20 };
                    Table prTable = new Table(7);
                    prTable.setWidth(100);
                    prTable.setWidths(poHeaderTop);
                    prTable.setBorderColor(blackColor);
                    prTable.setBorderWidth(1);
                    prTable.setAlignment(1);
                    prTable.setCellpadding(0);
                    prTable.setCellspacing(1);
                    
                    
                    //space antar table
                    Cell titlePrCellTop = new Cell(new Chunk(" ", tableContent));
                    titlePrCellTop.setColspan(7);
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(new Color(255,255,255));
                    prTable.addCell(titlePrCellTop);
                    
                    //1
                    /*titlePrCellTop = new Cell(new Chunk("No", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);*/

                    titlePrCellTop = new Cell(new Chunk("Group/Category/Code-Name", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Price", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Qty", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Discount", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Total", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Unit", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Expired Date", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                //value-valuenya
                for(int i=0;i<vectorList.size();i++){
                    SessIncomingGoodsL igL = (SessIncomingGoodsL)vectorList.get(i);
                    
                    //1
                   /* int n = (i+1);
                    titlePrCellTop = new Cell(new Chunk(String.valueOf(n), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);*/
                    
                    titlePrCellTop = new Cell(new Chunk(igL.getGroup(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    

                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(igL.getPrice(), "#,###.##") , tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(""+igL.getQty(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(igL.getDiscount(), "#,###.##") , tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(JSPFormater.formatNumber(igL.getTotal(), "#,###.##") , tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(""+igL.getUnit(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk((igL.getExpiredDate()==null) ? "-" : JSPFormater.formatDate(igL.getExpiredDate(), "dd/MM/yyyy"), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    
                
                }
                
                    document.add(prTable);
            }
            
            
            
        //Subnya

            int approvalHeaderTop[] = { 30,15,10,10,15,10,15 };
            Table approvalTable = new Table(7);
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
            spaceCellTop.setColspan(7);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setColspan(7);
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

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(ig.getSubTotal(), "#,###.##"), tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            //Discount
            if(ig.getDiscount1()!=0){
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
            
            spaceCellTop = new Cell(new Chunk(ig.getDiscount1()+" % ", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(ig.getDiscount2(), "#,###.##"), tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            }
            
            
            //Vat
            if(ig.getVat1()!=0){
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
            
            spaceCellTop = new Cell(new Chunk(ig.getVat1()+" % ", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(ig.getVat2(), "#,###.##"), tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_RIGHT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            }
            
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

            spaceCellTop = new Cell(new Chunk(JSPFormater.formatNumber(ig.getGrandTotal(), "#,###.##"), tableContent));
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
            
        }catch(Exception e){
        
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

