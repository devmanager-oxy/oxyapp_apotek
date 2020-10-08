/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.crm.pdf;

import com.lowagie.text.BadElementException;
import com.lowagie.text.Cell;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.Table;
import com.lowagie.text.pdf.PdfWriter;
import com.project.system.DbSystemProperty;
import com.project.util.JSPFormater;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
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
public class ARSummaryPdf extends HttpServlet {
    
    public ARSummaryPdf() {
        
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
    
    public static Font fontTitle = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD|Font.UNDERLINE, blackColor);
    
    public static Font fontHeader = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.NORMAL, blackColor);
    public static Font fontHeaderBU = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD|Font.UNDERLINE, blackColor);
    public static Font fontHeaderBI = FontFactory.getFont(FontFactory.HELVETICA, 14, Font.BOLD|Font.ITALIC, blackColor);
    public static Font fontContent = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL, Color.BLACK);
    public static Font fontContentB = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD, Color.BLACK);
    public static Font fontContentBI = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLDITALIC, Color.BLACK);
    public static Font fontContentStrike = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL|Font.STRIKETHRU, Color.BLACK);
    
    public static Font fontHeaderS = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL, blackColor);
    public static Font fontHeaderSB = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD, blackColor);
    public static Font fontContentS = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.NORMAL, Color.BLACK);
    public static Font fontContentSB = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLD, Color.BLACK);
    public static Font fontContentSBI = FontFactory.getFont(FontFactory.HELVETICA, 8, Font.BOLDITALIC, Color.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document(PageSize.A4.rotate(), 20, 20, 30, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            Vector vSummary = (Vector) session.getValue("SESS_AR_SUMMARY");
            
            String IMAGE_PRINT_PATH_CRM = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH_CRM");
            String pathLogo = IMAGE_PRINT_PATH_CRM + "btdc-logo-black-white.gif";
            Image logo = null;

            try {
                logo = Image.getInstance(pathLogo);
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
            
            document.open();
            document.add(getSummary(document, vSummary, logo));

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
    
    private static Table getSummary(Document document, Vector vSummary, Image logo)
            throws BadElementException, DocumentException {
        Table summary = new Table(12);
        int[] colWidth = {2, 6, 20, 2, 9, 2, 9, 13, 13, 5, 5, 14};
        summary.setWidths(colWidth);
        summary.setWidth(100);
        summary.setCellpadding(1);
        summary.setCellspacing(1);
        summary.setBorderColor(whiteColor);
        
        //logo.scalePercent(35);
        //logo.setAbsolutePosition(160, 515);
        //document.add(logo);
        
        for(int i=0; i<vSummary.size(); i++) {
            AR ar = (AR) vSummary.get(i);
            
            if(i == 0) {
                summary.setDefaultCellBorder(Table.NO_BORDER);
                summary.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
                summary.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
                summary.setDefaultRowspan(1);
                summary.setDefaultColspan(12);
                summary.addCell(new Phrase(ar.getTitle(), fontHeaderSB));
                summary.addCell(new Phrase("", fontContent));

                summary.setDefaultCellBorder(Table.LEFT | Table.TOP | Table.RIGHT | Table.BOTTOM);
                summary.setDefaultRowspan(2);
                summary.setDefaultColspan(1);
                summary.addCell(new Phrase("No", fontContentSB));
                summary.addCell(new Phrase("Lot", fontContentSB));
                summary.addCell(new Phrase("Investor", fontContentSB));
                summary.setDefaultRowspan(2);
                summary.setDefaultColspan(2);
                summary.addCell(new Phrase("Komin/Th", fontContentSB));
                summary.addCell(new Phrase("Asses/Th", fontContentSB));
                summary.setDefaultRowspan(1);
                summary.setDefaultColspan(2);
                summary.addCell(new Phrase("Perhitungan", fontContentSB));
                summary.addCell(new Phrase("Masa", fontContentSB));
                summary.setDefaultRowspan(2);
                summary.setDefaultColspan(1);
                summary.addCell(new Phrase("Keterangan", fontContentSB));
                
                summary.setDefaultRowspan(1);
                summary.setDefaultColspan(1);
                summary.addCell(new Phrase("Komin", fontContentSB));
                summary.addCell(new Phrase("Asses", fontContentSB));
                summary.addCell(new Phrase("Komin", fontContentSB));
                summary.addCell(new Phrase("Asses", fontContentSB));
            }
            
            summary.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.RIGHT|Table.BOTTOM);
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            summary.addCell(new Phrase(String.valueOf(i+1), fontContentS));
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            summary.addCell(new Phrase(ar.getLot(), fontContentS));
            summary.addCell(new Phrase(ar.getInvestor(), fontContentS));
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            summary.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.BOTTOM);
            summary.addCell(new Phrase(ar.getKominCurr(), fontContentS));
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            summary.setDefaultCellBorder(Table.TOP|Table.RIGHT|Table.BOTTOM);
            summary.addCell(new Phrase(JSPFormater.formatNumber(ar.getKomin(), "#,###.##"), fontContentS));
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            summary.setDefaultCellBorder(Table.LEFT|Table.TOP|Table.BOTTOM);
            summary.addCell(new Phrase(ar.getAssesCurr(), fontContentS));
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
            summary.setDefaultCellBorder(Table.TOP|Table.RIGHT|Table.BOTTOM);
            summary.addCell(new Phrase(JSPFormater.formatNumber(ar.getAsses(), "#,###"), fontContentS));
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
            summary.addCell(new Phrase(ar.getKominNote(), fontContentS));
            summary.addCell(new Phrase(ar.getAssesNote(), fontContentS));
            summary.addCell(new Phrase(ar.getKominMasa(), fontContentS));
            summary.addCell(new Phrase(ar.getAssesMasa(), fontContentS));
            summary.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
            summary.addCell(new Phrase(ar.getNote(), fontContentS));
        }
        
        return summary;
    }

}
