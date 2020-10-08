/*
 * RptGLStandardPDF.java
 *
 * Created on May 7, 2008, 7:07 AM
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
import com.project.fms.session.*;
import com.project.I_Project;

import com.project.general.Company;
import com.project.general.DbCompany;


/**
 *
 * @author  Suarjaya
 */
public class RptGLStandardPDF extends HttpServlet {
    
    /** Creates a new instance of RptSampleFlatPDF */
    public RptGLStandardPDF() {
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
    /*        
        public static Color blackColor = new Color(170, 170, 170);
        public static Color whiteColor = new Color(255, 255, 255);
        public static Color selectedColor = new Color(102,102,153);
        public static Color titleColor = new Color(58,149,97);    
        public static Color headerColor = new Color(108,163,90);
        public static Color contentColor = new Color(198,220,190);
    */
    public static Color border = new Color(0x00, 0x00, 0x00);    
    public static Color blackColor = new Color(0, 0, 0);
    public static Color whiteColor = new Color(255, 255, 255);
    public static Color titleColor = new Color(0, 0, 0);    
    public static Color headerColor = new Color(232, 232, 238);
    public static Color headerColor1 = new Color(230, 230, 230);
    public static Color contentColor = new Color(255, 255, 255);
    public static String formatDate = "dd MMMM yyyy";
    public static String formatNumber = "#,###";
       
    // Header Fonts
    public static Font fontCompany = FontFactory.getFont(FontFactory.HELVETICA,14,Font.BOLD,blackColor);
    public static Font fontTitle = FontFactory.getFont(FontFactory.HELVETICA,12,Font.BOLD,titleColor);
    public static Font fontAddress = FontFactory.getFont(FontFactory.HELVETICA,10,Font.NORMAL,blackColor);
    public static Font fontContact = FontFactory.getFont(FontFactory.HELVETICA,12,Font.NORMAL,blackColor);
    public static Font fontDate = FontFactory.getFont(FontFactory.HELVETICA,8,Font.NORMAL,blackColor);
    public static Font fontDate1 = FontFactory.getFont(FontFactory.HELVETICA,9,Font.BOLD,blackColor);      
    public static Font fontDate2 = FontFactory.getFont(FontFactory.HELVETICA,10,Font.BOLD,blackColor);      
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD,blackColor); 
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL,Color.BLACK); 
    public static Font fontContentBold = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD,Color.BLACK); 
    public static Font fontContentBoldItalic = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 8, Font.UNDERLINE,Color.BLACK); 
    
    /** Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, java.io.IOException {
        
        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document(PageSize.A4.rotate(), 20, 20, 20, 20);
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
                        
            // Add Header/Footer
            HeaderFooter footer = new HeaderFooter(new Phrase("Date : _________________                                         Date : _________________                                         Date : _________________\n            Approve by                                                                   Review by                                                                     Prepare by\n\n\n\n______________________                                          ______________________                                          ______________________", fontDate1), false);
            //HeaderFooter footer = new HeaderFooter(new Phrase("          Date : _________________                                                                     Date : _________________\n    Finance Manager                                                                                         Employee\n\n\n\n        _____________________                                                                       _____________________", fontDate1), false);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setBorder(Rectangle.BOTTOM);
            footer.setBorderColor(whiteColor);
            //document.setFooter(footer);
                        
            document.open();
            
            // Load Company
            Company company = DbCompany.getCompany();
            long oidCompany = company.getOID();                       
            
            // Load User Login
            String loginId = JSPRequestValue.requestString(request, "oid");
            
            long segmentId = 0;
            String locationName = "";
            try{
                segmentId = JSPRequestValue.requestLong(request, "segmentId");
                SegmentDetail sd = DbSegmentDetail.fetchExc(segmentId);
                locationName = sd.getName();
            }catch(Exception e){}

            // Load Date
            String strPeriod = JSPRequestValue.requestString(request, "period");

            // Load Invoice Item
            Vector vectorList = new Vector(1,1);
            try{
                HttpSession session = request.getSession();
                vectorList = (Vector)session.getValue("GL_REPORT_PDF");
            } catch (Exception e) { System.out.println(e); }                     

            // Load Path Images           
            String pathImage = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH")+"\\report_logo.jpg";            
            
            // Load Structure                                  
            document.add(getTableHeader(locationName,oidCompany, pathImage, writer, document,strPeriod));              
            Table tblContent = getTableHeaderContent(writer, document);                               
            getTableContent(locationName,tblContent, writer, document, vectorList, oidCompany, pathImage,strPeriod);                  
           
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
          
    public static Table getTableHeader(String locationName,long companyOID, String pathImage, PdfWriter writer, Document document, String strPeriod) throws BadElementException, DocumentException {         
        Table tableHeader = new Table(3);      
       
        int widthHead[] = {15,70,15};
        tableHeader.setWidths(widthHead);
        tableHeader.setWidth(100);
        tableHeader.setBorderColor(whiteColor);
        tableHeader.setCellpadding(0);
        tableHeader.setCellspacing(2);
        
        Company company = new Company();
        try{
            company = DbCompany.fetchExc(companyOID);
        }catch(Exception e){}
          
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
        if(locationName.length() > 0){
            cellHeader.setRowspan(4);
        }else{
            cellHeader.setRowspan(3);
        }
        //cellHeader.add(gambar);
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
        
        if(locationName.length() > 0){
            cellHeader = new Cell(new Chunk(locationName.toUpperCase(),fontCompany));
            cellHeader.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellHeader.setVerticalAlignment(Cell.ALIGN_TOP);
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(Color.WHITE);
            cellHeader.setColspan(1);
            tableHeader.addCell(cellHeader);
            
            cellHeader = new Cell(new Chunk("", fontCompany));
            cellHeader.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellHeader.setBorderColor(whiteColor);
            cellHeader.setBackgroundColor(Color.WHITE);
            cellHeader.setColspan(1);
            tableHeader.addCell(cellHeader);
        }
      
        /*Add header row 2 Col 1*/        
        cellHeader = new Cell(new Chunk("GENERAL LEDGER", fontTitle));
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
        
        //Periode periode = DbPeriode.getOpenPeriod();
        //String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");
        
        /*Add header row 3 Col 1*/        
        cellHeader = new Cell(new Chunk(strPeriod, fontContact));
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
        Table tableHeaderContent = new Table(7);      
                
        int widthHead[] = {5,10,10,30,15,15,15};
        tableHeaderContent.setWidths(widthHead);
        tableHeaderContent.setWidth(100);        
        tableHeaderContent.setBorderColor(whiteColor);
        tableHeaderContent.setCellpadding(1);
        tableHeaderContent.setCellspacing(0);                
     
        /*Add header row 1 Col 1*/

        return tableHeaderContent;               
    }
        
    public static void getTableContent(String locationName,Table tableContent, PdfWriter writer, Document document, Vector vectorList, long oidCompany, String pathImage, String strPeriod) throws BadElementException, DocumentException {
        int iHeader = 0;
        for(int i=0; i<vectorList.size(); i++){
            SesReportGl srb = (SesReportGl)vectorList.get(i);

            // Load SesReportGL list
            if(srb.getType().equals("Coa")){
                iHeader = i;
                /*Add header row 1 Col 1*/            
                Cell cellContent = new Cell(new Chunk("  "+srb.getDescription(),fontContentBold));
                cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor);              
                cellContent.setColspan(5);
                tableContent.addCell(cellContent);

                /*Add header row 1 Col 2*/
                cellContent = new Cell(new Chunk(srb.getAccGroup()+"  ",fontContentBold));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);
                cellContent.setBackgroundColor(headerColor);
                cellContent.setColspan(2);
                tableContent.addCell(cellContent);            
            }

            if(srb.getType().equals("Header")){
                /*Add header row 2 Col 1*/
                Cell cellContent = new Cell(new Chunk("",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 2*/
                cellContent = new Cell(new Chunk("Transaction Date",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 3*/
                cellContent = new Cell(new Chunk("Journal Number",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 4*/
                cellContent = new Cell(new Chunk("Memo",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 5*/
                cellContent = new Cell(new Chunk("Debet",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 6*/
                cellContent = new Cell(new Chunk("Credit",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 7*/
                cellContent = new Cell(new Chunk("Balance",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    
            }
            
            if(srb.getType().equals("Detail")){
                /*Add header row 2 Col 1*/
                Cell cellContent = new Cell(new Chunk("",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 2*/
                cellContent = new Cell(new Chunk(srb.getStrTransDate(),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 3*/
                cellContent = new Cell(new Chunk(srb.getJournalNumber(),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 4*/
                cellContent = new Cell(new Chunk(srb.getMemo(),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 5*/
                cellContent = new Cell(new Chunk(strDisplay(srb.getDebet(),""),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 6*/
                cellContent = new Cell(new Chunk(strDisplay(srb.getCredit(),""),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 7*/
                cellContent = new Cell(new Chunk(strDisplay(srb.getBalance(),""),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    
            }
            if(srb.getType().equals("Total")){

                /*Add header row 2 Col 3*/
                Cell cellContent = new Cell(new Chunk("",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(contentColor);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 4*/
                cellContent = new Cell(new Chunk("Total  ",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                cellContent.setColspan(3);
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 5*/
                cellContent = new Cell(new Chunk(strDisplay(srb.getDebet(),""),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 6*/
                cellContent = new Cell(new Chunk(strDisplay(srb.getCredit(),""),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

                /*Add header row 2 Col 7*/
                cellContent = new Cell(new Chunk(strDisplay(srb.getBalance(),""),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);            
                cellContent.setBorderColor(whiteColor);            
                cellContent.setBackgroundColor(headerColor1);                        
                tableContent.addCell(cellContent);    

            }
            
            if(!writer.fitsPage(tableContent) && false){
                int iX = i - iHeader+1;
                //i=i-2;
                for(int iH=0;iH<iX;iH++){
                    tableContent.deleteLastRow();                
                }
                i=iHeader-1;
                                
                document.add(tableContent);
                document.newPage();
                document.add(getTableHeader(locationName,oidCompany, pathImage, writer, document, strPeriod));                              
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
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(contentColor);
            cellContent.setColspan(7);
            tableContent.addCell(cellContent);            
            
            blankNum = blankNum + 1;
            
            if(!writer.fitsPage(tableContent)){
                if(blankNum>7){
                    tableContent.deleteLastRow();                    
                    tableContent.deleteLastRow();                    
                    tableContent.deleteLastRow();                
                    tableContent.deleteLastRow();                
                    
                    tableContent.deleteLastRow();                
                    tableContent.deleteLastRow();                
                    tableContent.deleteLastRow();                
                    tableContent.deleteLastRow();                
                    tableContent.deleteLastRow();                
                }
                else{
                    tableContent.deleteLastRow();     
                    document.add(tableContent);
                    document.newPage();
                    document.add(getTableHeader(locationName,oidCompany, pathImage, writer, document,strPeriod));                              
                    tableContent = getTableHeaderContent(writer,document);                                    
                }
                endRows = true;
            }
            
            if(endRows){            
                cellContent = new Cell(new Chunk("Date : _________________                                                   Date : _________________                                                   Date : _________________\n            Approve by                                                                             Review by                                                                               Prepare by\n\n\n\n______________________                                                    ______________________                                                    ______________________",fontContent));            
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(whiteColor);                
                cellContent.setBackgroundColor(contentColor);
                cellContent.setColspan(7);
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

    public static String strDisplay(double amount, String coaStatus){
            String displayStr = "";
            if(amount<0)
                    displayStr = "("+JSPFormater.formatNumber(amount*-1,"#,###.##")+")";
            else if(amount>0)										
                    displayStr = JSPFormater.formatNumber(amount,"#,###.##");
            else if(amount==0)
                    displayStr = "";
            if(coaStatus.equals("HEADER"))
                    displayStr = "";
            return displayStr;
    }
}
