/*
 * RptBankAccLinkFlatPDF.java
 *
 * Created on December 21, 2007, 11:28 AM
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

import com.project.general.Company;
import com.project.general.DbCompany;


public class RptTitipanAndKembaliPDF extends HttpServlet {
    
    /** Creates a new instance of RptSampleFlatPDF */
    public RptTitipanAndKembaliPDF() {
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
    public static Font fontDate1 = FontFactory.getFont(FontFactory.HELVETICA,9,Font.BOLD,blackColor);      
    public static Font fontDate2 = FontFactory.getFont(FontFactory.HELVETICA,10,Font.BOLD,blackColor);      
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
            
            /* adding a Header of page, i.e. : title, align and etc */
            HeaderFooter footer = new HeaderFooter(new Phrase("Date : _________________                                         Date : _________________                                         Date : _________________\n            Approve by                                                                   Review by                                                                     Prepare by\n\n\n\n______________________                                          ______________________                                          ______________________", fontDate1), false);
            //HeaderFooter footer = new HeaderFooter(new Phrase("          Date : _________________                                                                     Date : _________________\n    Finance Manager                                                                                         Employee\n\n\n\n        _____________________                                                                       _____________________", fontDate1), false);
            footer.setAlignment(Element.ALIGN_CENTER);
            footer.setBorder(Rectangle.BOTTOM);
            footer.setBorderColor(whiteColor);
            document.setFooter(footer);
            
            document.open();
            
            HttpSession sessOpname = request.getSession(true);         
    
            Vector vectMain = new Vector(1, 1);
            
            Company company = DbCompany.getCompany();
            long oidCompany = company.getOID();           
            
            String loginId = JSPRequestValue.requestString(request, "oid");
            System.out.println("UserId : "+loginId);
            
            //=========== TYPE REPORT ==================
            int typeReport = JSPRequestValue.requestInt(request, "type");
            
            String CashReceiptId = JSPRequestValue.requestString(request, "crd_id");
            long cashReceiptId = Long.parseLong(CashReceiptId);
                        
            Vector vectorList = DbCashReceiveDetail.list(0, DbCashReceiveDetail.getCount("")," cash_receive_id = "+cashReceiptId,"");
            
            String pathImage = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH")+"\\report_logo.jpg";
            //String pathImage = "login.jpg";
            System.out.println("PATH IMAGE = "+pathImage);
                      
            document.add(getTableHeader(oidCompany, pathImage, writer, document, cashReceiptId, typeReport)); //done             
            document.add(getTableHeaderContent1(writer, document, cashReceiptId));                 //done
            //document.add(getTableHeaderContent(writer, document));                                 //done
            Table tblContent = getTableHeaderContent(writer, document);
            //document.add(tblContent);
            getTableContent(tblContent, writer, document,vectorList, cashReceiptId);                  
            
            //document.add(getTableSpace(cashReceiptId));
            
            //document.add(getTableFooter(oidCompany, pathImage, writer, document, loginId));            
                                                
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
    
    public static Table getTableSpace(long cashReceiptId) throws BadElementException, DocumentException {
        Vector vectorList = DbCashReceive.list(0, DbCashReceive.getCount("")," cash_receive_id = "+cashReceiptId,"");
        
        CashReceive cashReceive = new CashReceive();
        try{	
            cashReceive = DbCashReceive.fetchExc(cashReceiptId);
        }
        catch(Exception e){}    
        Table tableSpace = new Table(8);      
       
        int widthHead[] = {10,10,4,10,8,10,10,10};
        tableSpace.setWidths(widthHead);
        tableSpace.setWidth(100);
        tableSpace.setBorderColor(whiteColor);
        tableSpace.setCellpadding(0);
        tableSpace.setCellspacing(2);
        
         /*Add header row 0*/
        /*Cell cellSpace = new Cell(new Chunk("",fontDate));
        cellSpace.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellSpace.setVerticalAlignment(Cell.ALIGN_TOP);
        cellSpace.setBorderColor(blackColor);
        cellSpace.setBorder(Cell.TOP);
        cellSpace.setBackgroundColor(Color.WHITE);        
        cellSpace.setColspan(8);
        tableSpace.addCell(cellSpace);
        
        /*Add header row 1 Col 1*/
        Cell cellSpace = new Cell(new Chunk("Amount Total",fontHeader));
        cellSpace.setHorizontalAlignment(Cell.ALIGN_RIGHT);
        cellSpace.setVerticalAlignment(Cell.ALIGN_TOP);
        cellSpace.setBorderColor(blackColor);
        cellSpace.setBorder(Cell.TOP);
        cellSpace.setBackgroundColor(Color.WHITE);
        cellSpace.setColspan(5);
        tableSpace.addCell(cellSpace);

        /*Add header row 1 Col 2*/
        cellSpace = new Cell(new Chunk(JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##"),fontHeader));
        cellSpace.setHorizontalAlignment(Cell.ALIGN_RIGHT);
        cellSpace.setVerticalAlignment(Cell.ALIGN_TOP);
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
    
    public static Table getTableHeader(long companyOID, String pathImage, PdfWriter writer, Document document, long cashReceiptId, int typeReport) throws BadElementException, DocumentException {         
        Vector vectorList = DbCashReceive.list(0, DbCashReceive.getCount("")," cash_receive_id = "+cashReceiptId,"");
        
        CashReceive cashReceive = new CashReceive();
        try{	
            cashReceive = DbCashReceive.fetchExc(cashReceiptId);
        }
        catch(Exception e){}    
        Table tableHeader = new Table(3);      
       
        int widthHead[] = {20,55,25};
        tableHeader.setWidths(widthHead);
        tableHeader.setWidth(100);
        tableHeader.setBorderColor(whiteColor);
        //tableHeader.setBorder(Table.BOTTOM | Table.TOP | Table.LEFT | Table.RIGHT);
        tableHeader.setCellpadding(0);
        tableHeader.setCellspacing(2);
        
        Company company = new Company();
        try{
            company = DbCompany.fetchExc(companyOID);
        }
        catch(Exception e){
        }
          
        //fontLsHeader
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
        //cellHeader = new Cell(new Chunk("Printed : "+ JSPFormater.formatDate(cashReceive.getTransDate(), formatDate),fontDate));
        cellHeader = new Cell(new Chunk("Printed : "+ JSPFormater.formatDate(new Date(), formatDate),fontDate));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_RIGHT);
        cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeader.setBorderColor(whiteColor);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(1);
        tableHeader.addCell(cellHeader);
      
        /*Add header row 2 Col 1*/        
        cellHeader = new Cell(new Chunk(""+((typeReport==1)?"TITIPAN":"PENGEMBALIAN TITIPAN")+"", fontCompany));
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

        Periode periode = DbPeriode.getPeriodByTransDate(cashReceive.getTransDate());
        String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");
        
        
        /*Add header row 3 Col 1*/        
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
        Table tableHeaderContent = new Table(8);      
       
        int widthHead[] = {10,10,4,10,8,10,10,10};
        tableHeaderContent.setWidths(widthHead);
        tableHeaderContent.setWidth(100);        
        tableHeaderContent.setBorderColor(blackColor);
        tableHeaderContent.setBorder(1);
        //tableHeaderContent.setBorder(Table.BOTTOM | Table.TOP | Table.LEFT | Table.RIGHT);
        tableHeaderContent.setCellpadding(1);
        tableHeaderContent.setCellspacing(1);                
     
        /*Add header row 1 Col 1*/
        Cell cellHeaderContent = new Cell(new Chunk("Account - Description",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.BLACK);
        //cellHeaderContent.setBorder(Cell.BOTTOM);
        cellHeaderContent.setBackgroundColor(headerColor);
        cellHeaderContent.setColspan(2);
        cellHeaderContent.setRowspan(2);
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 2*/
        cellHeaderContent = new Cell(new Chunk("Currency",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.BLACK);
        //cellHeaderContent.setBorder(Cell.BOTTOM);
        cellHeaderContent.setBackgroundColor(headerColor);
        cellHeaderContent.setColspan(2);
        tableHeaderContent.addCell(cellHeaderContent);
        
        /*Add header row 1 Col 3*/
        cellHeaderContent = new Cell(new Chunk("Booked Rate",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.BLACK);
        //cellHeaderContent.setBorder(Cell.BOTTOM);
        cellHeaderContent.setBackgroundColor(headerColor);        
        cellHeaderContent.setRowspan(2);
        tableHeaderContent.addCell(cellHeaderContent);
        
        /*Add header row 1 Col 4*/
        cellHeaderContent = new Cell(new Chunk("Amount IDR",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.BLACK);
        //cellHeaderContent.setBorder(Cell.BOTTOM);
        cellHeaderContent.setBackgroundColor(headerColor);
        cellHeaderContent.setRowspan(2);
        tableHeaderContent.addCell(cellHeaderContent);       

        /*Add header row 1 Col 5*/
        cellHeaderContent = new Cell(new Chunk("Description",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.BLACK);
        //cellHeaderContent.setBorder(Cell.BOTTOM);
        cellHeaderContent.setBackgroundColor(headerColor);
        cellHeaderContent.setRowspan(2);
        cellHeaderContent.setColspan(2);
        tableHeaderContent.addCell(cellHeaderContent);       
        
        /*Add header row 2 Col 1*/
        cellHeaderContent = new Cell(new Chunk("Code",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.BLACK);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.TOP);
        cellHeaderContent.setBackgroundColor(headerColor);        
        tableHeaderContent.addCell(cellHeaderContent);       

        /*Add header row 2 Col 2*/
        cellHeaderContent = new Cell(new Chunk("Amount",fontHeader));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.BLACK);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.TOP);
        cellHeaderContent.setBackgroundColor(headerColor);        
        tableHeaderContent.addCell(cellHeaderContent);       
        
        return tableHeaderContent;               
    }
    
    public static Table getTableHeaderContent1(PdfWriter writer, Document document, long cashReceiptId) throws BadElementException, DocumentException {
            
        Vector vectorList = DbCashReceive.list(0, DbCashReceive.getCount("")," cash_receive_id = "+cashReceiptId,"");
        
        CashReceive cashReceive = new CashReceive();
        try{	
            cashReceive = DbCashReceive.fetchExc(cashReceiptId);
        }
        catch(Exception e){}    
        
        Table tableHeaderContent = new Table(5);                         

        int widthHead[] = {10,20,5,10,15};
        tableHeaderContent.setWidths(widthHead);
        tableHeaderContent.setWidth(100);  
        tableHeaderContent.setBorderColor(whiteColor);
        //tableHeaderContent.setBorder(Table.BOTTOM | Table.TOP | Table.LEFT | Table.RIGHT);
        tableHeaderContent.setCellpadding(0);
        tableHeaderContent.setCellspacing(0);        

        // Load CashReceive list

        /*Add header row 1 Col 1*/
        Cell cellHeaderContent = new Cell(new Chunk("Terima Pada Akun",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 2*/
            Coa c = new Coa();
            try{	
                c = DbCoa.fetchExc(cashReceive.getCoaId());
            }
            catch(Exception e){}               

        cellHeaderContent = new Cell(new Chunk(c.getCode()+" - "+c.getName(),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 3*/
        cellHeaderContent = new Cell(new Chunk("",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);     
        tableHeaderContent.addCell(cellHeaderContent); 
        
        /*Add header row 1 Col 4*/
        cellHeaderContent = new Cell(new Chunk("Nomor Jurnal",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);            
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 1 Col 5*/
        cellHeaderContent = new Cell(new Chunk(cashReceive.getJournalNumber(),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);     
        tableHeaderContent.addCell(cellHeaderContent);
        
        /*Add header row 2 Col 1*/
        cellHeaderContent = new Cell(new Chunk("Petugas Penerima",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 2 Col 2*/
        Employee emp = new Employee();
            try{	
                emp = DbEmployee.fetchExc(cashReceive.getReceiveFromId());
            }
            catch(Exception e){}    
        
        cellHeaderContent = new Cell(new Chunk(emp.getEmpNum() +" "+ emp.getName() ,fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 2 Col 3*/
        cellHeaderContent = new Cell(new Chunk("",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);     
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 2 Col 4*/
        cellHeaderContent = new Cell(new Chunk("Tanggal Transaksi",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);            
        tableHeaderContent.addCell(cellHeaderContent);

        /*Add header row 2 Col 5*/
        cellHeaderContent = new Cell(new Chunk(JSPFormater.formatDate(cashReceive.getTransDate(), "dd-MMM-yyyy"),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);     
        tableHeaderContent.addCell(cellHeaderContent);
        
        cellHeaderContent = new Cell(new Chunk("Memo",fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);
        tableHeaderContent.addCell(cellHeaderContent);
        
        cellHeaderContent = new Cell(new Chunk(cashReceive.getMemo(),fontContent));
        cellHeaderContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeaderContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeaderContent.setBorderColor(Color.WHITE);
        //cellHeaderContent.setBorder(Cell.BOTTOM | Cell.RIGHT | Cell.LEFT | Cell.TOP);
        cellHeaderContent.setBackgroundColor(contentColor);
        cellHeaderContent.setColspan(4);
        tableHeaderContent.addCell(cellHeaderContent);
        
        return tableHeaderContent;
    }
        
    public static void getTableContent(Table tableContent, PdfWriter writer, Document document, Vector vectorList, long oidRec) throws BadElementException, DocumentException {
        
        CashReceive cashReceive = new CashReceive();
        try{	
            cashReceive = DbCashReceive.fetchExc(oidRec);
        }
        catch(Exception e){}    
        
        for(int i=0; i<vectorList.size(); i++){
            
            CashReceiveDetail cashReceiveDetail = (CashReceiveDetail)vectorList.get(i);

        //for(int i=0; i<100; i++){
            //CashReceiveDetail cashReceiveDetail = (CashReceiveDetail)vectorList.get(0);
        
            //Table tableContent = new Table(8);      

            //int widthHead[] = {10,10,4,10,6,10,10,10};
        /*    int widthHead[] = {10,10,4,10,8,10,10,10};
            tableContent.setWidths(widthHead);
            tableContent.setWidth(100);  
            tableContent.setBorderColor(whiteColor);
            //tableContent.setBorder(Table.BOTTOM | Table.TOP | Table.LEFT | Table.RIGHT);
            tableContent.setCellpadding(0);
            tableContent.setCellspacing(3); 
        
         */       
        
            // Load CashReceiveDetail list
            
            /*Add header row 1 Col 1*/
                Coa c = new Coa();
                try{	
                    c = DbCoa.fetchExc(cashReceiveDetail.getCoaId());
                }
                catch(Exception e){}
                
                String str = "";
                

            
                Cell cellContent = new Cell(new Chunk(c.getCode()+" - "+c.getName(),fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
                cellContent.setBackgroundColor(contentColor);
                cellContent.setColspan(2);
                tableContent.addCell(cellContent);            
            
            /*Add header row 1 Col 2*/
                Currency curr = new Currency();
                try{	
                    curr = DbCurrency.fetchExc(cashReceiveDetail.getForeignCurrencyId());
                }
                catch(Exception e){}

            cellContent = new Cell(new Chunk(curr.getCurrencyCode(),fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);
            
            /*Add header row 1 Col 3*/
            cellContent = new Cell(new Chunk(JSPFormater.formatNumber(cashReceiveDetail.getForeignAmount(), "#,###.##"),fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);

            /*Add header row 1 Col 4*/
            cellContent = new Cell(new Chunk(JSPFormater.formatNumber(cashReceiveDetail.getBookedRate(), "#,###.##"),fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);

            /*Add header row 1 Col 5*/
            cellContent = new Cell(new Chunk(JSPFormater.formatNumber(cashReceiveDetail.getAmount(), "#,###.##"),fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);
            
            /*Add header row 1 Col 6*/
            cellContent = new Cell(new Chunk(cashReceiveDetail.getMemo(),fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);  
            cellContent.setColspan(2);
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
        
        //document.add(tableContent);                               
        
        boolean endRows = false;
        int blankNum = 0;
        
        while(!endRows){
            Cell cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);
            cellContent.setColspan(2);
            tableContent.addCell(cellContent);            
            
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);
            
            /*Add header row 1 Col 3*/
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);

            /*Add header row 1 Col 4*/
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);

            /*Add header row 1 Col 5*/
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);
            
            /*Add header row 1 Col 6*/
            cellContent = new Cell(new Chunk("",fontContent));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(Color.BLACK);
            //cellContent.setBorder(Cell.BOTTOM | Cell.TOP);
            cellContent.setBackgroundColor(contentColor);  
            cellContent.setColspan(2);
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
                cellContent.setColspan(5);
                tableContent.addCell(cellContent);            

                /*Add header row 1 Col 5*/
                cellContent = new Cell(new Chunk("",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                cellContent.setBorder(Cell.TOP);
                cellContent.setBackgroundColor(contentColor);            
                tableContent.addCell(cellContent);

                /*Add header row 1 Col 6*/
                cellContent = new Cell(new Chunk("",fontContent));
                cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                cellContent.setBorder(Cell.TOP);
                cellContent.setBackgroundColor(contentColor);  
                cellContent.setColspan(2);
                tableContent.addCell(cellContent);
                
                //-----------
                
                cellContent = new Cell(new Chunk("",fontContent));            
                cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                cellContent.setBorder(Cell.RIGHT);
                cellContent.setBackgroundColor(contentColor);
                cellContent.setColspan(4);
                tableContent.addCell(cellContent);            

                /*Add header row 1 Col 5*/
                cellContent = new Cell(new Chunk("TOTAL AMOUNT",fontDate2));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                //cellContent.setBorder(Cell.BOTTOM | Cell.TOP | Cell.RIGHT);
                cellContent.setColspan(2);
                cellContent.setBackgroundColor(headerColor);            
                tableContent.addCell(cellContent);

                /*Add header row 1 Col 6*/
                cellContent = new Cell(new Chunk(JSPFormater.formatNumber(cashReceive.getAmount(), "#,###.##"),fontDate2));
                cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(Color.BLACK);
                //cellContent.setBorder(Cell.BOTTOM | Cell.TOP | Cell.RIGHT);
                cellContent.setBackgroundColor(headerColor);  
                cellContent.setColspan(2);
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
