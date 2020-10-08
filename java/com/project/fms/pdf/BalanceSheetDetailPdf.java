package com.project.fms.pdf;

import com.lowagie.text.BadElementException;
import com.lowagie.text.Cell;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;
import com.project.general.Company;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.util.Date;
import java.util.Vector;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author gwawan
 */
public class BalanceSheetDetailPdf extends HttpServlet {
    
    public BalanceSheetDetailPdf() {
        
    }

    public void init(ServletConfig config) throws ServletException {
        super.init(config);
    }

    /** Destroys the servlet.
     */
    public void destroy() {

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
    public static Color border = new Color(0x00, 0x00, 0x00);
    public static Color blackColor = new Color(0, 0, 0);
    public static Color whiteColor = new Color(255, 255, 255);
    public static Color titleColor = new Color(0, 0, 0);
    public static Color headerColor = new Color(232, 232, 238);
    public static Color contentColor = new Color(255, 255, 255);
    public static String formatDate = "dd MMMM yyyy";
    public static String formatNumber = "#,###";
    
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, blackColor);
    public static Font fontHeaderB = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD, blackColor);
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, Color.BLACK);
    public static Font fontContentB = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, Color.BLACK);
    public static Font fontHeaderFooter = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, Color.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        Document document = new Document(PageSize.A4, 10, 2, 10, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            Vector vReport = (Vector) session.getValue("SESS_BALANCESHEETDETAIL_PDF");
            
            String IMAGE_PRINT_PATH = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH");
            String pathLogo = IMAGE_PRINT_PATH + "btdc-logo-black-white.gif";
            Image logo = null;

            try {
                logo = Image.getInstance(pathLogo);
            } catch (Exception ex) {
                System.out.println("[Exception] "+ pathLogo +" not found: ");
            }
            
            HeaderFooter footer = new HeaderFooter(new Phrase("Page ", fontHeaderFooter), true);
            footer.setBorder(Rectangle.NO_BORDER);
            footer.setAlignment(Cell.ALIGN_RIGHT);
            document.setFooter(footer);

            if (logo != null) {
                logo.setAlignment(Image.MIDDLE);
                logo.scalePercent(35);
                logo.setAbsolutePosition(20, 760);
                Chunk chunk = new Chunk(logo, 0, 0);
                HeaderFooter header = new HeaderFooter(new Phrase(chunk), false);
                header.setAlignment(Element.ALIGN_LEFT);
                header.setBorder(Rectangle.NO_BORDER);
                document.setHeader(header);
            }
            
            document.open();
            getReport(document, vReport);

        } catch (Exception e) {
            System.out.println("Exception Draw pdf : " + e.toString());
        }

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
    
    public static void getReport(Document document, Vector vReport) throws BadElementException, DocumentException {
        Table report = new Table(4);
        int[] colWidth = {5, 63, 16, 16};
        report.setWidths(colWidth);
        report.setWidth(100);
        report.setCellpadding(1);
        report.setCellspacing(1);
        report.setBorderColor(whiteColor);
        
        if(vReport != null && vReport.size() > 0) {
            Company company = (Company)vReport.get(0);
            String title = (String)vReport.get(1);
            Date reportDate = (Date)vReport.get(2);
            Vector vRow = (Vector)vReport.get(3);
            
            Date lastYear = (Date)reportDate.clone();
            lastYear.setYear(lastYear.getYear()-1);
            
            report.setDefaultCellBorder(Table.NO_BORDER);
            report.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            report.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
            report.setDefaultRowspan(1);
            report.setDefaultColspan(4);
            report.addCell(new Phrase(company.getName(), fontHeaderB));
            report.addCell(new Phrase(title.toUpperCase(), fontHeaderB));
            report.addCell(new Phrase("PER "+JSPFormater.formatDate(lastYear, "dd MMM yyyy").toUpperCase()+" DAN "+JSPFormater.formatDate(reportDate, "dd MMM yyyy").toUpperCase(), fontHeaderB));
            
            report.setDefaultRowspan(1);
            report.setDefaultColspan(4);
            report.addCell(new Phrase("", fontHeaderB));
            
            report.setDefaultRowspan(2);
            report.setDefaultColspan(1);
            report.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
            report.addCell(new Phrase("NO", fontContentB));
            report.addCell(new Phrase("URAIAN", fontContentB));
            report.setDefaultRowspan(1);
            report.setDefaultColspan(1);
            report.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT);
            report.addCell(new Phrase("REALISASI PER ", fontContentB));
            report.addCell(new Phrase("REALISASI PER ", fontContentB));
            
            report.setDefaultRowspan(1);
            report.setDefaultColspan(1);
            report.setDefaultCellBorder(Table.LEFT|Table.RIGHT|Table.BOTTOM);
            report.addCell(new Phrase(JSPFormater.formatDate(lastYear, "dd MMM yyyy").toUpperCase(), fontContentB));
            report.addCell(new Phrase(JSPFormater.formatDate(reportDate, "dd MMM yyyy").toUpperCase(), fontContentB));
            
            //mark end of header
            report.endHeaders();
            
            int n = 0;
            if(vRow != null && vRow.size() > 0) {
                for(int i=0; i<vRow.size(); i++) {
                    BalanceSheet bs = (BalanceSheet)vRow.get(i);
                    
                    String level = "";
                    switch(bs.getLevel()) {
                        case 1:
                            level = "  ";
                            break;
                        case 2:
                            level = "    ";
                            break;
                        case 3:
                            level = "      ";
                            break;
                        case 4:
                            level = "        ";
                            break;
                        case 5:
                            level = "          ";
                            break;
                        case 6:
                            level = "            ";
                            break;
                        case 7:
                            level = "              ";
                            break;
                        default:
                            level = "";
                            break;
                    }
                    
                    if(bs.isNewPage()) {
                        document.add(report);
                        
                        document.newPage();
                        report = new Table(4);
                        report.setWidths(colWidth);
                        report.setWidth(100);
                        report.setCellpadding(1);
                        report.setCellspacing(1);
                        report.setBorderColor(whiteColor);
                        
                        report.setDefaultCellBorder(Table.NO_BORDER);
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                        report.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
                        report.setDefaultRowspan(1);
                        report.setDefaultColspan(4);
                        report.addCell(new Phrase(company.getName(), fontHeaderB));
                        report.addCell(new Phrase(title.toUpperCase(), fontHeaderB));
                        report.addCell(new Phrase("PER " + JSPFormater.formatDate(lastYear, "dd MMM yyyy").toUpperCase() + " DAN " + JSPFormater.formatDate(reportDate, "dd MMM yyyy").toUpperCase(), fontHeaderB));

                        report.setDefaultRowspan(1);
                        report.setDefaultColspan(4);
                        report.addCell(new Phrase("", fontHeaderB));

                        report.setDefaultRowspan(2);
                        report.setDefaultColspan(1);
                        report.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
                        report.addCell(new Phrase("NO", fontContentB));
                        report.addCell(new Phrase("URAIAN", fontContentB));
                        report.setDefaultRowspan(1);
                        report.setDefaultColspan(1);
                        report.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT);
                        report.addCell(new Phrase("REALISASI PER ", fontContentB));
                        report.addCell(new Phrase("REALISASI PER ", fontContentB));

                        report.setDefaultRowspan(1);
                        report.setDefaultColspan(1);
                        report.setDefaultCellBorder(Table.LEFT | Table.RIGHT | Table.BOTTOM);
                        report.addCell(new Phrase(JSPFormater.formatDate(lastYear, "dd MMM yyyy").toUpperCase(), fontContentB));
                        report.addCell(new Phrase(JSPFormater.formatDate(reportDate, "dd MMM yyyy").toUpperCase(), fontContentB));

                        //mark end of header
                        report.endHeaders();
                    }
                    
                    report.setDefaultRowspan(1);
                    report.setDefaultColspan(1);
                    
                    if(i == (vRow.size()-1))report.setDefaultCellBorder(Table.LEFT|Table.RIGHT|Table.BOTTOM);
                    else report.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                    
                    if(bs.isNewPage()) document.newPage();
                    
                    if (bs.isLabel()) {
                        report.addCell(new Phrase("", fontContent));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                        report.addCell(new Phrase(bs.getDescription(), fontContentB));
                        report.addCell(new Phrase("", fontContentB));
                        report.addCell(new Phrase("", fontContentB));
                        n = 0;
                    } else if (bs.isTotal()) {
                        report.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
                        report.addCell(new Phrase("", fontContent));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                        report.addCell(new Phrase(level + bs.getDescription(), fontContentB));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                        report.addCell(new Phrase(toAccountingFormat(bs.getRealLY()), fontContentB));
                        report.addCell(new Phrase(toAccountingFormat(bs.getRealCY()), fontContentB));
                    } else if (bs.isBoldText()) {
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                        report.addCell(new Phrase(String.valueOf(n + 1), fontContent));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                        report.addCell(new Phrase(level + bs.getDescription(), fontContentB));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                        report.addCell(new Phrase(toAccountingFormat(bs.getRealLY()), fontContentB));
                        report.addCell(new Phrase(toAccountingFormat(bs.getRealCY()), fontContentB));
                        n++;
                    } else {
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                        report.addCell(new Phrase(String.valueOf(n + 1), fontContent));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                        report.addCell(new Phrase(level + bs.getDescription(), fontContent));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                        report.addCell(new Phrase(toAccountingFormat(bs.getRealLY()), fontContent));
                        report.addCell(new Phrase(toAccountingFormat(bs.getRealCY()), fontContent));
                        n++;
                    }
                }
            }
        }
        
        document.add(report);
    }
    
    private static String toAccountingFormat(double value){
        String CURRFORMAT = "#,###";
        try {
            CURRFORMAT = DbSystemProperty.getValueByName("CURR_FORMAT");
        } catch(Exception e) {}
        
        String sValue = "";
        
        if(value < -0.5) {
            sValue = "("+JSPFormater.formatNumber(value*-1, CURRFORMAT)+")";
        } else if(value > 0.5) {
            sValue = JSPFormater.formatNumber(value, CURRFORMAT);
        } else {
            sValue = "0";
        }
        
        return sValue;
    }

}
