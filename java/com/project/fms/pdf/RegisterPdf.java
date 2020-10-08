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
import com.project.fms.transaction.DbBankRegister;
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
public class RegisterPdf  extends HttpServlet {
    
    public RegisterPdf() {
        
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
            Vector vReport = (Vector) session.getValue("SESS_REGISTER_PDF");
            
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
        Table report = new Table(7);
        int[] colWidth = {14, 8, 20, 21, 12, 12, 13};
        report.setWidths(colWidth);
        report.setWidth(100);
        report.setCellpadding(1);
        report.setCellspacing(1);
        report.setBorderColor(whiteColor);
        
        if(vReport != null && vReport.size() > 0) {
            Company company = (Company)vReport.get(0);
            String title = (String)vReport.get(1);
            Date reportDate = (Date)vReport.get(2);
            String coa = (String)vReport.get(3);
            Vector vRow = (Vector)vReport.get(4);
            
            Date lastYear = (Date)reportDate.clone();
            lastYear.setYear(lastYear.getYear()-1);
            
            report.setDefaultCellBorder(Table.NO_BORDER);
            report.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            report.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
            report.setDefaultRowspan(1);
            report.setDefaultColspan(7);
            report.addCell(new Phrase(company.getName(), fontHeaderB));
            report.addCell(new Phrase(title.toUpperCase(), fontHeaderB));
            report.addCell(new Phrase("Tanggal : "+JSPFormater.formatDate(reportDate, "dd-MM-yyyy").toUpperCase(), fontHeaderB));
            report.addCell(new Phrase(coa, fontHeaderB));
            
            report.setDefaultRowspan(1);
            report.setDefaultColspan(7);
            report.addCell(new Phrase("", fontHeaderB));
            
            report.setDefaultRowspan(2);
            report.setDefaultColspan(1);
            report.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
            report.addCell(new Phrase("NOMOR", fontContentB));
            report.addCell(new Phrase("STATUS", fontContentB));
            report.addCell(new Phrase("DARI/KEPADA", fontContentB));
            report.addCell(new Phrase("URAIAN", fontContentB));
            report.setDefaultRowspan(1);
            report.setDefaultColspan(2);
            report.addCell(new Phrase("JUMLAH", fontContentB));
            report.setDefaultRowspan(2);
            report.setDefaultColspan(1);
            report.addCell(new Phrase("SALDO", fontContentB));
            
            report.setDefaultRowspan(1);
            report.setDefaultColspan(1);
            report.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
            report.addCell(new Phrase("DEBET", fontContentB));
            report.addCell(new Phrase("KREDIT", fontContentB));
            
            //mark end of header
            report.endHeaders();
            
            if(vRow != null && vRow.size() > 0) {
                for(int i=0; i<vRow.size(); i++) {
                    Register register = (Register)vRow.get(i);
                    
                    report.setDefaultRowspan(1);
                    report.setDefaultColspan(1);
                    
                    if(i == (vRow.size()-1))report.setDefaultCellBorder(Table.LEFT|Table.RIGHT|Table.BOTTOM);
                    else report.setDefaultCellBorder(Table.LEFT|Table.RIGHT);
                    
                    if (register.isBoldText()) {
                        report.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                        report.addCell(new Phrase("", fontContentB));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                        report.addCell(new Phrase("", fontContentB));
                        report.addCell(new Phrase("", fontContentB));
                        report.addCell(new Phrase(register.getDescription(), fontContentB));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                        report.addCell(new Phrase(toAccountingFormat(register.getDebet()), fontContentB));
                        report.addCell(new Phrase(toAccountingFormat(register.getCredit()), fontContentB));
                        report.addCell(new Phrase(toAccountingFormat(register.getSaldo()), fontContentB));
                    } else {
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                        report.addCell(new Phrase(register.getDocNumber(), fontContent));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
                        report.addCell(new Phrase(register.getDocNumber().equals("")?"":DbBankRegister.strBankRegisterStatus[register.getStatus()], fontContent));
                        report.addCell(new Phrase(register.getName(), fontContent));
                        report.addCell(new Phrase(register.getDescription(), fontContent));
                        report.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
                        report.addCell(new Phrase(toAccountingFormat(register.getDebet()), fontContent));
                        report.addCell(new Phrase(toAccountingFormat(register.getCredit()), fontContent));
                        report.addCell(new Phrase(toAccountingFormat(register.getSaldo()), fontContent));
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
