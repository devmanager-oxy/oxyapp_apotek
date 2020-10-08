/*
 * RptPurchaseRequestPdf.java
 *
 * Created on January 16, 2009, 10:41 PM
 */

package com.project.ccs.report;

/**
 *
 * @author  Kyo
 */

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


public class RptPurchaseRequestPdf extends HttpServlet {
   
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
        System.out.println("===| RptPurchaseRequestPdf |===");
        //long oidEmployee = FRMQueryString.requestLong(request, "oid");
        
        SessPurchaseRequest pr = new SessPurchaseRequest(); 
        try{
            HttpSession session = request.getSession();
            pr = (SessPurchaseRequest)session.getValue("PURCHASE_TITTLE");
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
            HeaderFooter header = new HeaderFooter(new Phrase(""+cmp.getName()+"\n"+cmp.getAddress()+"\nPurchase Request"+""), false);
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
            
            
            Cell titleCellHeader = new Cell(new Chunk("PURCHASE REQUEST", fontTitle));
            titleCellHeader.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellHeader.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellHeader.setColspan(7);
            titleCellHeader.setBorderColor(new Color(255,255,255));
            titleTable.addCell(titleCellHeader);

            titleCellHeader = new Cell(new Chunk(""+cmp.getName().toUpperCase()+"", fontContent));
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
            

            int purchaseHeaderTop[] = {15,5,40,15,15,5,40};
            Table purchaseTable = new Table(7);
            purchaseTable.setWidth(100);
            purchaseTable.setWidths(purchaseHeaderTop);
            purchaseTable.setBorderColor(new Color(255,255,255));
            purchaseTable.setBorderWidth(0);
            purchaseTable.setAlignment(1);
            purchaseTable.setCellpadding(0);
            purchaseTable.setCellspacing(1);

             //0
            /*
            Cell titleCellTop = new Cell(new Chunk("Purchase Request", fontContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setColspan(7);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
             */

            Cell titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setColspan(7);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            

            //1Employee Number
            titleCellTop = new Cell(new Chunk("Department", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);

            titleCellTop = new Cell(new Chunk(pr.getDepartment(), tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
   
            titleCellTop = new Cell(new Chunk("", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk("Number", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(":", tableContent));
            titleCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);
            
            titleCellTop = new Cell(new Chunk(pr.getNumber(), tableContent));
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

            titleCellTop = new Cell(new Chunk(JSPFormater.formatDate((pr.getDate()==null) ? new Date() : pr.getDate(), "dd/MM/yyyy"), tableContent));
            titleCellTop.setColspan(5);
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

            titleCellTop = new Cell(new Chunk(pr.getNotes(), tableContent));
            titleCellTop.setColspan(5);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            purchaseTable.addCell(titleCellTop);

            document.add(purchaseTable);
            
 //Listnya
                 
        if(vectorList!=null && vectorList.size()>0){
                
                    //membuat table 
                    int prHeaderTop[] = { 2,10,10,10,10,10,10 };
                    Table prTable = new Table(7);
                    prTable.setWidth(100);
                    prTable.setWidths(prHeaderTop);
                    prTable.setBorderColor(new Color(255,255,255));
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
                    titlePrCellTop = new Cell(new Chunk("No", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Product - Item", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk("Group", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("Category", fontHeader));
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
                    
                    titlePrCellTop = new Cell(new Chunk("Unit", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk("PO Status", fontHeader));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    titlePrCellTop.setBackgroundColor(bgColor);
                    prTable.addCell(titlePrCellTop);
                    
                //value-valuenya
                for(int i=0;i<vectorList.size();i++){
                    SessPurchaseRequestL prL = (SessPurchaseRequestL)vectorList.get(i);
                    
                    //1
                    int n = (i+1);
                    titlePrCellTop = new Cell(new Chunk(String.valueOf(n), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(prL.getProduct(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);

                    titlePrCellTop = new Cell(new Chunk(prL.getGroup(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(prL.getCategory(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(""+prL.getQty(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk(prL.getUnit(), tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                    titlePrCellTop = new Cell(new Chunk((prL.getPoStatus()==-1)? "-" : DbPurchaseRequestItem.strItemStatus[prL.getPoStatus()], tableContent));
                    titlePrCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
                    titlePrCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
                    titlePrCellTop.setBorderColor(blackColor);
                    prTable.addCell(titlePrCellTop);
                    
                }
                
                    document.add(prTable);
            }
         
  //Approval and Prepared By

            int approvalHeaderTop[] = {10,10,10,7,10,10,10};
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
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setColspan(7);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            titleCellTop = new Cell(new Chunk(" ", tableContent));
            titleCellTop.setColspan(7);
            titleCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            titleCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            titleCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk(" ", fontContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setColspan(7);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(" ", tableContent));
            spaceCellTop.setColspan(7);
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk(" ", fontContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setColspan(7);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk(" ", tableContent));
            spaceCellTop.setColspan(7);
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            spaceCellTop = new Cell(new Chunk(" ", tableContent));
            spaceCellTop.setColspan(7);
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);
            
            

            //Prepared By and Approval BY
            spaceCellTop = new Cell(new Chunk("Prepared By", tableContent));
            spaceCellTop.setColspan(3);
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("", tableContent));
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            spaceCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            spaceCellTop.setBorderColor(new Color(255,255,255));
            approvalTable.addCell(spaceCellTop);

            spaceCellTop = new Cell(new Chunk("Approval By", tableContent));
            spaceCellTop.setColspan(3);
            spaceCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
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

 //Linenya
            signCellTop = new Cell(new Chunk("", tableContent));
            signCellTop.setColspan(3);
            signCellTop.setBorder(Rectangle.BOTTOM);
            signCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCellTop.setBorderColor(blackColor);
            signTable.addCell(signCellTop);

            signCellTop = new Cell(new Chunk("", tableContent));
            signCellTop.setHorizontalAlignment(Element.ALIGN_CENTER);
            signCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCellTop.setBorderColor(new Color(255,255,255));
            signTable.addCell(signCellTop);

            signCellTop = new Cell(new Chunk("", tableContent));
            signCellTop.setColspan(3);
            signCellTop.setBorder(Rectangle.BOTTOM);
            signCellTop.setHorizontalAlignment(Element.ALIGN_LEFT);
            signCellTop.setVerticalAlignment(Element.ALIGN_MIDDLE);
            signCellTop.setBorderColor(blackColor);
            signTable.addCell(signCellTop);

            document.add(signTable);  
            
            
             
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