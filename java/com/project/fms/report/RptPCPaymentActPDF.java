/*
 * RptPCPaymentActivityPDF.java
 *
 * Created on February 3, 2008, 8:05 AM 
 * Author : Suarjaya
 */

package com.project.fms.report;

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
import com.project.general.Currency;
import com.project.general.DbCurrency;
import com.project.system.*;
import com.project.fms.activity.*;

import com.project.general.Company;
import com.project.general.DbCompany;


public class RptPCPaymentActPDF extends HttpServlet {
    
    /** Creates a new instance of RptSampleFlatPDF */
    public RptPCPaymentActPDF() {
    }
    
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }
    
    /** Destroys the servlet.
     */
    public void destroy() {
        
    }
    
    // setting session
    public static String SESS_PRINT_OPNAME = "SESS_PRINT_OPNAME";
    // setting the color values
    
    public static Color border = new Color(0x00, 0x00, 0x00);    
    public static Color blackColor = new Color(0, 0, 0);
    public static Color whiteColor = new Color(255, 255, 255);
    public static Color titleColor = new Color(0, 0, 0);    
    public static Color headerColor = new Color(232, 232, 238);
    public static Color contentColor = new Color(255, 255, 255);
    public static String formatDate = "dd MMMM yyyy";
    public static String formatNumber = "#,###";
       
    // Header Fonts
    public static Font fontCompany = FontFactory.getFont(FontFactory.HELVETICA,14,Font.BOLD,blackColor);
    public static Font fontTitle = FontFactory.getFont(FontFactory.HELVETICA,16,Font.BOLD,titleColor);
    public static Font fontAddress = FontFactory.getFont(FontFactory.HELVETICA,10,Font.NORMAL,blackColor);
    public static Font fontContact = FontFactory.getFont(FontFactory.HELVETICA,12,Font.NORMAL,blackColor);
    public static Font fontDate = FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL,blackColor);  
    public static Font fontDate1 = FontFactory.getFont(FontFactory.HELVETICA,8,Font.BOLD,blackColor); 
    public static Font fontDate2 = FontFactory.getFont(FontFactory.HELVETICA,9,Font.BOLD,blackColor);      
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD,blackColor); 
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL,Color.BLACK); 
    public static Font fontContentBold = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD,Color.BLACK); 
            
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        
        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document(PageSize.A4, 20, 20, 20, 20);
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
                        
            // Add Header/Footer
            HeaderFooter footer = new HeaderFooter(new Phrase("Date : _________________                                         Date : _________________                                         Date : _________________\n            Approve by                                                                   Review by                                                                     Prepare by\n\n\n\n______________________                                          ______________________                                          ______________________", fontDate1), false);
            //HeaderFooter footer = new HeaderFooter(new Phrase("          Date : _________________                                                                     Date : _________________\n    Finance Manager                                                                                         Employee\n\n\n\n        _____________________                                                                       _____________________", fontDate1), false);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setBorder(Rectangle.BOTTOM);
            footer.setBorderColor(whiteColor);
            document.setFooter(footer);
                        
            document.open();
            
            // Load Company
            Company company = DbCompany.getCompany();
            long oidCompany = company.getOID();           
            System.out.println("oidCompany : "+oidCompany);
            
            // Load User Login
            String loginId = JSPRequestValue.requestString(request, "oid");
            System.out.println("UserId : "+loginId);

            // Load Payment
            String PCPaymentId = JSPRequestValue.requestString(request, "pcPayment_id");
            long pcPaymentId = Long.parseLong(PCPaymentId);
            PettycashPayment pettycashPayment = DbPettycashPayment.fetchExc(pcPaymentId);
            System.out.println("PaymentId : "+PCPaymentId);
            
            // Load Payment Activity Detail
            Vector vectorList = DbTransactionActivityDetail.list(0, DbTransactionActivityDetail.getCount(""),"transaction_id = "+pcPaymentId,"");

            // Load Path Images           
            String pathImage = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH")+"\\report_logo.jpg";
            System.out.println("PATH IMAGE = "+pathImage);
            
            // Load Structure                      
            document.add(getTableHeader(oidCompany, pathImage, writer, document, vectorList, pettycashPayment));                          
            document.add(getTableHeaderContent1(writer, document, pettycashPayment));                                            
            Table tblContent = getTableHeaderContent(writer, document);            
            getTableContent(tblContent, writer, document, vectorList, pettycashPayment);                  
                                                                                            
        } catch (Exception e) {
            System.out.println("Exception Draw pdf : " + e.toString());
        }
        
        // step 5: closing the document
        document.close();
        
        // we have written the pdfstream to a ByteArrayOutputStream,
        // now we are going to write this outputStream to the ServletOutputStream
        // after we have set the contentlength (see http://www.lowagie.com/iText/faq.html#msie)
        response.setContentType("application/pdf");
        response.setContentLength(baos.size());
        ServletOutputStream out = response.getOutputStream();
        baos.writeTo(out);
        out.flush();
    }
    
    public static Table getTableSpace(long pcPaymentId) throws BadElementException, DocumentException {
        Vector vectorList = DbPettycashPayment.list(0, DbPettycashPayment.getCount("")," pettycash_payment_id = "+pcPaymentId,"");
        
        PettycashPayment pettycashPayment = new PettycashPayment();
        try{	
            //pettycashPayment = DbPettycashPayment.fetchExc(pcPaymentId);
             pettycashPayment = (PettycashPayment)vectorList.get(0);
        }
        catch(Exception e){}    
        Table tableSpace = new Table(5);      
       
        int widthHead[] = {10,10,10,10,10};
        tableSpace.setWidths(widthHead);
        tableSpace.setWidth(100);
        tableSpace.setBorderColor(whiteColor);
        tableSpace.setCellpadding(0);
        tableSpace.setCellspacing(2);
        
         /*Add header row 0*/
        Cell cellSpace = new Cell(new Chunk("",fontDate));
        cellSpace.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellSpace.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellSpace.setBorderColor(blackColor);
        cellSpace.setBorder(Cell.TOP);
        cellSpace.setBackgroundColor(Color.WHITE);        
        cellSpace.setColspan(1);
        tableSpace.addCell(cellSpace);
        
        /*Add header row 1 Col 1*/
        cellSpace = new Cell(new Chunk("Amount Total",fontHeader));
        cellSpace.setHorizontalAlignment(Cell.ALIGN_RIGHT);
        cellSpace.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellSpace.setBorderColor(blackColor);
        cellSpace.setBorder(Cell.TOP);
        cellSpace.setBackgroundColor(Color.WHITE);
        cellSpace.setColspan(1);
        tableSpace.addCell(cellSpace);

        /*Add header row 1 Col 2*/
        cellSpace = new Cell(new Chunk(JSPFormater.formatNumber(pettycashPayment.getAmount(), "#,###.##"),fontHeader));
        //System.out.println("Amount total : "+pettycashPayment.getAmount());
        cellSpace.setHorizontalAlignment(Cell.ALIGN_RIGHT);
        cellSpace.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellSpace.setBorderColor(blackColor);
        cellSpace.setBorder(Cell.TOP);
        cellSpace.setBackgroundColor(Color.WHITE);
        cellSpace.setColspan(1);
        tableSpace.addCell(cellSpace);
        
        /*Add header row 1 Col 3*/
        cellSpace = new Cell(new Chunk("",fontDate));
        cellSpace.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellSpace.setVerticalAlignment(Cell.ALIGN_TOP);
        cellSpace.setBorderColor(blackColor);
        cellSpace.setBorder(Cell.TOP);
        cellSpace.setBackgroundColor(Color.WHITE);
        cellSpace.setColspan(2);
        tableSpace.addCell(cellSpace);
        
       
        return tableSpace;        
     }
    
    public static Table getTableFooter(long companyOID, String pathImage, PdfWriter writer, Document document, String loginId) throws BadElementException, DocumentException {
        Table tableFooter = new Table(3);      
        
        int widthHead[] = {20,5,20};
        tableFooter.setWidths(widthHead);
        tableFooter.setWidth(100);
        tableFooter.setBorderColor(whiteColor);
        tableFooter.setCellpadding(0);
        tableFooter.setCellspacing(2);
                     
        /*Add header row 1 Col 1*/
        Cell cellFooter = new Cell(new Chunk("Finance Manager",fontDate));
        cellFooter.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellFooter.setVerticalAlignment(Cell.ALIGN_TOP);
        cellFooter.setBorderColor(whiteColor);
        cellFooter.setBackgroundColor(Color.WHITE);        
        tableFooter.addCell(cellFooter);

        /*Add header row 1 Col 2*/
        cellFooter = new Cell(new Chunk("",fontDate));
        cellFooter.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellFooter.setVerticalAlignment(Cell.ALIGN_TOP);
        cellFooter.setBorderColor(whiteColor);
        cellFooter.setBackgroundColor(Color.WHITE);
        tableFooter.addCell(cellFooter);
        
        /*Add header row 1 Col 3*/
        cellFooter = new Cell(new Chunk("Clerk",fontDate));
        cellFooter.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellFooter.setVerticalAlignment(Cell.ALIGN_TOP);
        cellFooter.setBorderColor(whiteColor);
        cellFooter.setBackgroundColor(Color.WHITE);
        tableFooter.addCell(cellFooter);
        
        /*Add header row 2*/
        cellFooter = new Cell(new Chunk("",fontDate));
        cellFooter.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellFooter.setVerticalAlignment(Cell.ALIGN_TOP);
        cellFooter.setBorderColor(whiteColor);
        cellFooter.setBackgroundColor(Color.WHITE);
        cellFooter.setRowspan(6);        
        cellFooter.setColspan(3);
        tableFooter.addCell(cellFooter);
        
        /*Add header row 3 Col 1*/
        cellFooter = new Cell(new Chunk("(                          )",fontDate));
        cellFooter.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellFooter.setVerticalAlignment(Cell.ALIGN_TOP);
        cellFooter.setBorderColor(whiteColor);
        cellFooter.setBackgroundColor(Color.WHITE);
        tableFooter.addCell(cellFooter);
        
        /*Add header row 3 Col 2*/
        cellFooter = new Cell(new Chunk("",fontDate));
        cellFooter.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellFooter.setVerticalAlignment(Cell.ALIGN_TOP);
        cellFooter.setBorderColor(whiteColor);
        cellFooter.setBackgroundColor(Color.WHITE);
        tableFooter.addCell(cellFooter);
        
        /*Add header row 3 Col 3*/
        //cellFooter = new Cell(new Chunk(loginId,fontDate));
        cellFooter = new Cell(new Chunk("(                          )",fontDate));
        cellFooter.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellFooter.setVerticalAlignment(Cell.ALIGN_TOP);
        cellFooter.setBorderColor(whiteColor);
        cellFooter.setBackgroundColor(Color.WHITE);
        tableFooter.addCell(cellFooter);
        
        return tableFooter;
    }
    
    public static Table getTableHeader(long companyOID, String pathImage, PdfWriter writer, Document document, Vector vectorList, PettycashPayment pettycashPayment) throws BadElementException, DocumentException {         
        Table tableHeader = new Table(3);             
        int widthHead[] = {20,55,25};
        tableHeader.setWidths(widthHead);
        tableHeader.setWidth(100);
        tableHeader.setBorderColor(whiteColor);
        tableHeader.setCellpadding(0);
        tableHeader.setCellspacing(2);
        
        Company company = new Company();
        try{
            company = DbCompany.fetchExc(companyOID);
        }
        catch(Exception e){
        }
          
        /*Add header row 1 Col 1*/        
        Image gambar = null;
        try {
            gambar = Image.getInstance(pathImage);
        } 
        catch (Exception ex) {
            System.out.println(ex.toString());
        }
       
        Cell cellHeader = new Cell(new Chunk("",fontCompany));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeader.setVerticalAlignment(Cell.ALIGN_TOP);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setRowspan(3);
        cellHeader.add(gambar);
        tableHeader.addCell(cellHeader);

        /*Add header row 1 Col 2*/
        cellHeader = new Cell(new Chunk(company.getName().toUpperCase(),fontCompany));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeader.setVerticalAlignment(Cell.ALIGN_TOP);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(1);
        tableHeader.addCell(cellHeader);

        /*Add header row 1 Col 3*/
        cellHeader = new Cell(new Chunk("Printed : "+ JSPFormater.formatDate(new Date(), formatDate),fontDate));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_RIGHT);
        cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(1);
        tableHeader.addCell(cellHeader);
      
        /*Add header row 2 Col 1*/        
        cellHeader = new Cell(new Chunk("PETTY CASH PAYMENT ACTIVITY", fontCompany));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(1);
        tableHeader.addCell(cellHeader);

        /*Add header row 2 Col 2*/        
        cellHeader = new Cell(new Chunk("", fontCompany));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(1);
        tableHeader.addCell(cellHeader);

        /*Add header row 3 Col 1*/        
        Periode periode = DbPeriode.getPeriodByTransDate(pettycashPayment.getTransDate());
        String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");
        cellHeader = new Cell(new Chunk("PERIOD "+ openPeriod.toUpperCase(), fontContact));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(1);
        tableHeader.addCell(cellHeader);

        /*Add header row 3 Col 2*/        
        cellHeader = new Cell(new Chunk("",fontCompany));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(1);
        tableHeader.addCell(cellHeader);              
        
        return tableHeader;        
    }
        
    public static Table getTableHeaderContent(PdfWriter writer, Document document) throws BadElementException, DocumentException {
        Table tableHeaderContent = new Table(4);      
       
        int widthHead[] = {10,35,35,20};
        tableHeaderContent.setWidths(widthHead);
        tableHeaderContent.setWidth(100);        
        tableHeaderContent.setBorderColor(whiteColor);
        tableHeaderContent.setCellpadding(1);
        tableHeaderContent.setCellspacing(1);                
     
        /*Add header row 1 Col 1*/
        Cell cellHeaderContent = new Cell(new Chunk("Type",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBackgroundColor(headerColor);        
        tableHeaderContent.addCell(cellHeaderContent);
        
        /*Add header row 1 Col 2*/
        cellHeaderContent = new Cell(new Chunk("Account",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBackgroundColor(headerColor);        
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 3*/
        cellHeaderContent = new Cell(new Chunk("Activity",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBackgroundColor(headerColor);
        tableHeaderContent.addCell(cellHeaderContent);
        
        /*Add header row 1 Col 4*/
        cellHeaderContent = new Cell(new Chunk("Amount IDR",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBackgroundColor(headerColor);        
        tableHeaderContent.addCell(cellHeaderContent);
       
        return tableHeaderContent;               
    }
    
    public static Table getTableHeaderContent1(PdfWriter writer, Document document, PettycashPayment pettycashPayment) throws BadElementException, DocumentException {
        Table tableHeaderContent = new Table(5);      
        int widthHead[] = {10,20,5,10,15};
        tableHeaderContent.setWidths(widthHead);
        tableHeaderContent.setWidth(100);  
        tableHeaderContent.setBorderColor(whiteColor);
        tableHeaderContent.setCellpadding(0);
        tableHeaderContent.setCellspacing(0);        

        // Load PettycashPayment list

        /*Add header row 1 Col 1*/
        Cell cellHeaderContent = new Cell(new Chunk("Payment from Account",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 2*/
            Coa c = new Coa();
            try{	
                c = DbCoa.fetchExc(pettycashPayment.getCoaId());
            }
            catch(Exception e){}               

        cellHeaderContent = new Cell(new Chunk(c.getCode()+" - "+c.getName(),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 3*/
        cellHeaderContent = new Cell(new Chunk("",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);     
        tableHeaderContent.addCell(cellHeaderContent); 
        
        /*Add header row 1 Col 4*/
        cellHeaderContent = new Cell(new Chunk("Journal Number",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);            
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 5*/
        cellHeaderContent = new Cell(new Chunk(pettycashPayment.getJournalNumber(),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);     
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 2 Col 4*/
        cellHeaderContent = new Cell(new Chunk("Transaction Date",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);            
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 2 Col 5*/
        cellHeaderContent = new Cell(new Chunk(JSPFormater.formatDate(pettycashPayment.getTransDate(), "dd-MMM-yyyy"),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);     
        tableHeaderContent.addCell(cellHeaderContent);
        
        cellHeaderContent = new Cell(new Chunk("",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor); 
        cellHeaderContent.setColspan(3);
        tableHeaderContent.addCell(cellHeaderContent);
        
        cellHeaderContent = new Cell(new Chunk("Memo",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);
        
        cellHeaderContent = new Cell(new Chunk(pettycashPayment.getMemo(),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        cellHeaderContent.setBackgroundColor(contentColor);
        cellHeaderContent.setColspan(4);
        tableHeaderContent.addCell(cellHeaderContent);
        
        return tableHeaderContent;
    }
        
    public static void getTableContent(Table tableContent, PdfWriter writer, Document document, Vector vectorList, PettycashPayment pettycashPayment) throws BadElementException, DocumentException {
        for(int i=0; i<vectorList.size(); i++){
            TransactionActivityDetail pcPaymentDetail = (TransactionActivityDetail)vectorList.get(i);

            // Load TransactionActivityDetail list
            
            /*Add header row 1 Col 1*/
            Cell cellContent = new Cell(new Chunk(DbTransactionActivityDetail.activities[pcPaymentDetail.getType()],fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);  
            tableContent.addCell(cellContent);
                                        
            /*Add header row 1 Col 2*/
            Coa xcoa = new Coa();
            try{
                xcoa = DbCoa.fetchExc(pcPaymentDetail.getCoaId());		
            }
            catch(Exception e){}                                    
            if(pcPaymentDetail.getCoaId()!=0){
                cellContent = new Cell(new Chunk(xcoa.getCode()+" - "+xcoa.getName(),fontContent));
            }else{
                cellContent = new Cell(new Chunk("Non Modular",fontContent));
            }            
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);    
           
            /*Add header row 1 Col 3*/
            Module mdl = new Module();
            try{
                mdl = DbModule.fetchExc(pcPaymentDetail.getModuleId());
            } catch(Exception e){}

            if(pcPaymentDetail.getModuleId()!=0){
                cellContent = new Cell(new Chunk(mdl.getCode()+" - "+mdl.getDescription(),fontContent));
            }else{
                cellContent = new Cell(new Chunk("Non Modular",fontContent));
            }
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);
            tableContent.addCell(cellContent);            
            
            /*Add header row 1 Col 4*/
            cellContent = new Cell(new Chunk(JSPFormater.formatNumber(pcPaymentDetail.getAmount(), "#,###.##"),fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);
                       
            if(!writer.fitsPage(tableContent)){
                i=i-2;
                tableContent.deleteLastRow();                
                tableContent.deleteLastRow();
                System.out.println("============TIDAK FIT============");
                document.add(tableContent);
                document.newPage();
                tableContent = getTableHeaderContent(writer,document);                                    
            }         
        }
        boolean endRows = false;
        int blankNum = 0;
        
        while(!endRows){
            /*Add header row 1 Col 1*/
            Cell cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);            

            /*Add header row 1 Col 2*/
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);    
           
            /*Add header row 1 Col 3*/
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);
            
            /*Add header row 1 Col 4*/
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBackgroundColor(contentColor);              
            tableContent.addCell(cellContent);
            
            blankNum = blankNum + 1;
            
            if(!writer.fitsPage(tableContent)){
                if(blankNum>3){
                    tableContent.deleteLastRow();                    
                    tableContent.deleteLastRow();                    
                    tableContent.deleteLastRow();                
                    tableContent.deleteLastRow();                
                }
                else{
                    tableContent.deleteLastRow();                
                }
                endRows = true;
            }
            
            if(endRows){
            
                cellContent = new Cell(new Chunk("",fontContent));            
                cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                cellContent.setBorder(Cell.TOP);
                cellContent.setBackgroundColor(contentColor);
                cellContent.setColspan(4);
                tableContent.addCell(cellContent);            
               
                //-----------
                
                cellContent = new Cell(new Chunk("",fontContent));            
                cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                cellContent.setBorder(Cell.RIGHT);
                cellContent.setBackgroundColor(contentColor);
                cellContent.setColspan(2);
                tableContent.addCell(cellContent);            

                /*Add header row 1 Col 5*/
                cellContent = new Cell(new Chunk("TOTAL",fontDate2));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                cellContent.setBackgroundColor(headerColor);            
                tableContent.addCell(cellContent);

                /*Add header row 1 Col 6*/
                double result = 0;
                if(vectorList!=null && vectorList.size()>0){
                        for(int i=0; i<vectorList.size(); i++){
                                TransactionActivityDetail crd = (TransactionActivityDetail)vectorList.get(i);
                                result = result + crd.getAmount();
                        }
                }
                double totalDetail = result;
                cellContent = new Cell(new Chunk(JSPFormater.formatNumber(totalDetail, "#,###.##"),fontDate2));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                cellContent.setBackgroundColor(headerColor);  
                tableContent.addCell(cellContent);
            }
            
        }
        document.add(tableContent);
    }
     
     /** Handles the HTTP <code>GET</code> method.
     * @param request servle t request
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
