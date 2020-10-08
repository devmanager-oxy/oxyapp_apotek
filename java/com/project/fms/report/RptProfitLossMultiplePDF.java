/*
 * RptProfitLossPDF.java
 *
 * Created on May 8, 2008, 11:28 AM
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
public class RptProfitLossMultiplePDF extends HttpServlet {
    
    /** Creates a new instance of RptSampleFlatPDF */
    public RptProfitLossMultiplePDF() {
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
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.NORMAL,Color.BLACK); 
    public static Font fontContentBold = FontFactory.getFont(FontFactory.HELVETICA, 7, Font.BOLD,Color.BLACK); 
    public static Font fontContentBoldItalic = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 7, Font.UNDERLINE,Color.BLACK); 
    
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
            System.out.println("oidCompany : "+oidCompany);
            
            // Load User Login
            String loginId = JSPRequestValue.requestString(request, "oid");
            System.out.println("UserId : "+loginId);

            // Load Year
            int year = JSPRequestValue.requestInt(request, "year");
            System.out.println("Year : "+year);
            
            Date dt = new Date();
            dt.setDate(1);
            dt.setMonth(0);
            int yearselect = year;
            dt.setYear(yearselect);
            
            Date endDate = (Date)dt.clone();
            endDate.setDate(31);
            endDate.setMonth(11);

            String where = " to_days(start_date) >= to_days('"+JSPFormater.formatDate(dt, "yyyy-MM-dd")+"')"+
                           " and to_days(end_date)<=to_days('"+JSPFormater.formatDate(endDate, "yyyy-MM-dd")+"')";

            Vector temp = DbPeriode.list(0,0, where, "start_date");
            boolean putTotal1 = false;
            boolean putTotal2 = false;
            Vector temp1 = new Vector();
            Vector temp2 = new Vector();
            if(temp.size()<7){
                temp1 = DbPeriode.list(0,6, where, "start_date");
                putTotal1 = true;
            }else if(temp.size()==7){
                temp1 = DbPeriode.list(0,6, where, "start_date");
                temp2 = DbPeriode.list(6,6, where, "start_date");                
                putTotal2 = true;
            }else if(temp.size()>7){
                temp1 = DbPeriode.list(0,7, where, "start_date");
                temp2 = DbPeriode.list(7,6, where, "start_date");                
                putTotal2 = true;
            }            
            
            System.out.println("Total vPeriod 1 : "+temp1.size());
            System.out.println("Total vPeriod 2 : "+temp2.size());
            System.out.println("Start Date : "+JSPFormater.formatDate(dt, "yyyy-MM-dd"));
            System.out.println("End Date : "+JSPFormater.formatDate(endDate, "yyyy-MM-dd"));
            
            // Load Item
            Vector vectorList = new Vector(1,1);
            try{
                HttpSession session = request.getSession();
                vectorList = (Vector)session.getValue("PROFIT_MULTIPLE");
            } catch (Exception e) { System.out.println(e); }

            // Load Path Images           
            String pathImage = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH")+"\\report_logo.jpg";
            System.out.println("PATH IMAGE = "+pathImage);
            
            // Load Structure                                  
            document.add(getTableHeader(oidCompany, pathImage, writer, document));              
            Table tblContent = getTableHeaderContent(writer, document, temp1, putTotal1);                               
            getTableContent(tblContent, writer, document, vectorList, oidCompany, pathImage, temp1, putTotal1);                  

            if(temp2.size()>0){            
                // Load Structure                                  
                document.add(getTableHeader(oidCompany, pathImage, writer, document));              
                Table tblContentX = getTableHeaderContent(writer, document, temp2, putTotal2);                               
                getTableContent(tblContentX, writer, document, vectorList, oidCompany, pathImage, temp2, putTotal2);                  
            }
            
           
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
          
    public static Table getTableHeader(long companyOID, String pathImage, PdfWriter writer, Document document) throws BadElementException, DocumentException {         
        Table tableHeader = new Table(3);      
       
        int widthHead[] = {10,75,15};
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
        cellHeader = new Cell(new Chunk("PROFIT & LOSS STATEMENT", fontTitle));
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
        
        Periode periode = DbPeriode.getOpenPeriod();        
        String openPeriod = JSPFormater.formatDate(periode.getStartDate(), "dd MMM yyyy")+ " - " + JSPFormater.formatDate(periode.getEndDate(), "dd MMM yyyy");
        
        /*Add header row 3 Col 1*/        
        cellHeader = new Cell(new Chunk("MULTIPLE PERIODS", fontContact));
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

        /*Add header row 4 Col 1*/        
        cellHeader = new Cell(new Chunk("",fontCompany));
        cellHeader.setHorizontalAlignment(Cell.ALIGN_LEFT);
        cellHeader.setVerticalAlignment(Cell.ALIGN_MIDDLE);
        cellHeader.setBorderColor(blackColor);
        cellHeader.setBorderWidth(1);
        cellHeader.setBorder(Cell.TOP);
        cellHeader.setBackgroundColor(Color.WHITE);
        cellHeader.setColspan(3);
        tableHeader.addCell(cellHeader);              

        return tableHeader;        
    }
    
    public static Table getTableHeaderContent(PdfWriter writer, Document document, Vector vDep, boolean putTotal) throws BadElementException, DocumentException {
        //Vector vDep = new Vector();
	//vDep = DbDepartment.list(0,0,"level=0","code");
        
        Table tableHeaderContent = new Table(3+vDep.size());              
              
        //int widthHead[] = {1};
        if(putTotal==true){
            switch(vDep.size())
            {
                case 1 :
                    int widthHead1[] = {180,60,60,0};
                    tableHeaderContent.setWidths(widthHead1);
                    break;            
                case 2 :
                    int widthHead2[] = {180,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead2);
                    break;            
                case 3 :
                    int widthHead3[] = {180,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead3);
                    break;            
                case 4 :
                    int widthHead4[] = {180,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead4);
                    break;            
                case 5 :
                    int widthHead5[] = {180,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead5);
                    break;            
                case 6 :
                    int widthHead6[] = {180,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead6);
                    break;            
                case 7 :
                    int widthHead7[] = {180,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead7);
                    break;            
                case 8 :
                    int widthHead8[] = {180,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead8);
                    break;            
                case 9 :
                    int widthHead9[] = {180,60,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead9);
                    break;            
                case 10 :
                    int widthHead10[] = {180,60,60,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead10);
                    break;            
                case 11 :
                    int widthHead11[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead11);
                    break;            
                case 12 :
                    int widthHead12[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead12);
                    break;            
                case 13 :
                    int widthHead13[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead13);
                    break;            
                case 14 :
                    int widthHead14[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead14);
                    break;
                case 15 :
                    int widthHead15[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,0};
                    tableHeaderContent.setWidths(widthHead15);
                    break;            
                default :
                    int widthHead0[] = {180,60,0};
                    tableHeaderContent.setWidths(widthHead0);
            }
        }else{
            switch(vDep.size())
            {
                case 1 :
                    int widthHead1[] = {180,60,0,0};
                    tableHeaderContent.setWidths(widthHead1);
                    break;            
                case 2 :
                    int widthHead2[] = {180,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead2);
                    break;            
                case 3 :
                    int widthHead3[] = {180,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead3);
                    break;            
                case 4 :
                    int widthHead4[] = {180,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead4);
                    break;            
                case 5 :
                    int widthHead5[] = {180,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead5);
                    break;            
                case 6 :
                    int widthHead6[] = {180,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead6);
                    break;            
                case 7 :
                    int widthHead7[] = {180,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead7);
                    break;            
                case 8 :
                    int widthHead8[] = {180,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead8);
                    break;            
                case 9 :
                    int widthHead9[] = {180,60,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead9);
                    break;            
                case 10 :
                    int widthHead10[] = {180,60,60,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead10);
                    break;            
                case 11 :
                    int widthHead11[] = {180,60,60,60,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead11);
                    break;            
                case 12 :
                    int widthHead12[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead12);
                    break;            
                case 13 :
                    int widthHead13[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead13);
                    break;            
                case 14 :
                    int widthHead14[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead14);
                    break;
                case 15 :
                    int widthHead15[] = {180,60,60,60,60,60,60,60,60,60,60,60,60,60,60,60,0,0};
                    tableHeaderContent.setWidths(widthHead15);
                    break;            
                default :
                    int widthHead0[] = {180,0,0};
                    tableHeaderContent.setWidths(widthHead0);
            }            
        }
        
        //int widthHead[] = {180,60,60,60,60,60,60,60,60,60,0};
        //tableHeaderContent.setWidths(widthHead);
        tableHeaderContent.setWidth(100);        
        tableHeaderContent.setBorderColor(whiteColor);
        tableHeaderContent.setCellpadding(0);
        tableHeaderContent.setCellspacing(0);                
     
        /*Add header row 1 Col 1*/
            Cell cellContent = new Cell(new Chunk("Description",fontContentBold));
            cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(headerColor);
            cellContent.setBackgroundColor(headerColor);              
            tableHeaderContent.addCell(cellContent);

            if(vDep!=null && vDep.size()>0)
            {
                for(int ix=0; ix<vDep.size(); ix++)
                {    
                    Periode per = (Periode)vDep.get(ix);	                    
                    /*Add header row 1 Col 2*/
                    cellContent = new Cell(new Chunk(per.getName(),fontContentBold));
                    cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
                    cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                    cellContent.setBorderColor(whiteColor);
                    cellContent.setBorder(Cell.LEFT);
                    cellContent.setBackgroundColor(headerColor);
                    tableHeaderContent.addCell(cellContent);            
                }
            }
            
            /*Add header row 1 Col 2*/
            if(putTotal==true){
                cellContent = new Cell(new Chunk("Total",fontContentBold));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(whiteColor);
                cellContent.setBorder(Cell.LEFT);
                cellContent.setBackgroundColor(headerColor);
                tableHeaderContent.addCell(cellContent);            
            }else{
                cellContent = new Cell(new Chunk("",fontContentBold));
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(whiteColor);
                cellContent.setBorder(Cell.LEFT);
                cellContent.setBackgroundColor(headerColor);
                tableHeaderContent.addCell(cellContent);                            
            }                

            /*Add header row 1 Col 3*/
            cellContent = new Cell(new Chunk("",fontContentBold));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(headerColor);
            cellContent.setBackgroundColor(headerColor);
            tableHeaderContent.addCell(cellContent);    
            
            
        return tableHeaderContent;               
    }
        
    public static void getTableContent(Table tableContent, PdfWriter writer, Document document, Vector vectorList, long oidCompany, String pathImage, Vector vDep, boolean putTotal) throws BadElementException, DocumentException {       

        for(int i=0; i<vectorList.size(); i++){
            SesReportBs srb = (SesReportBs)vectorList.get(i);

            // Load SesReportBs list
            
            /*Add header row 1 Col 1*/
            Font xFont = new Font();
            Font xFont1 = new Font();
            if (srb.getFont()==1){            
                if (srb.getType().equals("Footer Top Level"))
                    xFont1 = fontContentBoldItalic;
                else
                    xFont1 = fontContentBold;            
                xFont = fontContentBold;
            }else{
                xFont = fontContent;
                xFont1 = fontContent;
            }
            
            Cell cellContent = new Cell(new Chunk(srb.getDescription(),xFont));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(contentColor);  
            tableContent.addCell(cellContent);

            Vector vDepx = srb.getDepartment();
            if(vDep!=null && vDep.size()>0)
            {
                for(int ix=(vDepx.size()-vDep.size()); ix<vDepx.size(); ix++)
                {    
                    String strDep = "";
                    double dblDep = 0;
                    if(vDepx!=null && vDepx.size()>0)
                    {
                        strDep = (String)vDepx.get(ix);
                        try{
                            dblDep = Double.parseDouble(strDep);
                        }catch(Exception e){
                            System.out.println(e);
                        }
                    }
                    /*Add header row 1 Col 2*/
                    if(dblDep==0)
                        cellContent = new Cell(new Chunk("",xFont1));
                    else
                        cellContent = new Cell(new Chunk(strDisplay(dblDep,""),xFont1));
                    cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
                    cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                    cellContent.setBorderColor(whiteColor);
                    cellContent.setBackgroundColor(contentColor);
                    tableContent.addCell(cellContent);            
                }
            }
            
            /*Add header row 1 Col 2*/
            String strAmount = srb.getStrAmount();
            double dblAmount = 0;
            try{
                dblAmount = Double.parseDouble(strAmount);
            }catch(Exception e){
                System.out.println(e);
            }
            if(dblAmount==0 || putTotal==false)
                cellContent = new Cell(new Chunk("",xFont1));                
            else
                cellContent = new Cell(new Chunk(strDisplay(dblAmount,""),xFont1));
            cellContent.setHorizontalAlignment(Cell.ALIGN_RIGHT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(contentColor);
            tableContent.addCell(cellContent);            

            /*Add header row 1 Col 3*/
            cellContent = new Cell(new Chunk("",xFont));
            cellContent.setHorizontalAlignment(Cell.ALIGN_LEFT);
            cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
            cellContent.setBorderColor(whiteColor);
            cellContent.setBackgroundColor(contentColor);            
            tableContent.addCell(cellContent);    
                       
            if(!writer.fitsPage(tableContent)){
                i=i-2;
                tableContent.deleteLastRow();                
                tableContent.deleteLastRow();
                System.out.println("============TIDAK FIT============");
                document.add(tableContent);
                document.newPage();
                document.add(getTableHeader(oidCompany, pathImage, writer, document));                              
                tableContent = getTableHeaderContent(writer,document,vDep, putTotal);                                    
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
            cellContent.setColspan(3+vDep.size());
            tableContent.addCell(cellContent);            
            
            blankNum = blankNum + 1;
            
            if(!writer.fitsPage(tableContent)){
                if(blankNum>8){
                    tableContent.deleteLastRow();                    
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
                    document.add(getTableHeader(oidCompany, pathImage, writer, document));                              
                    tableContent = getTableHeaderContent(writer,document, vDep, putTotal);                                    
                }
                endRows = true;
            }
            
            if(endRows){            
                cellContent = new Cell(new Chunk("Date : _________________                                                   Date : _________________                                                   Date : _________________\n            Approve by                                                                             Review by                                                                               Prepare by\n\n\n\n______________________                                                    ______________________                                                    ______________________",fontContent));            
                cellContent.setHorizontalAlignment(Cell.ALIGN_CENTER);
                cellContent.setVerticalAlignment(Cell.ALIGN_MIDDLE);
                cellContent.setBorderColor(whiteColor);                
                cellContent.setBackgroundColor(contentColor);
                cellContent.setColspan(3+vDep.size());
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
