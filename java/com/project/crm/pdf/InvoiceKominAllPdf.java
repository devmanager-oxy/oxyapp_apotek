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
public class InvoiceKominAllPdf extends HttpServlet {

    public InvoiceKominAllPdf() {
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
    public static Font fontContentBold = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLD, Color.BLACK);
    public static Font fontContentArt = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.BOLDITALIC, Color.BLACK);
    public static Font fontContentStrike = FontFactory.getFont(FontFactory.HELVETICA, 11, Font.NORMAL|Font.STRIKETHRU, Color.BLACK);
    
    public static Font fontHeaderS = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.NORMAL, blackColor);
    public static Font fontHeaderBoldS = FontFactory.getFont(FontFactory.HELVETICA, 12, Font.BOLD|Font.UNDERLINE, blackColor);
    public static Font fontContentS = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.NORMAL, Color.BLACK);
    public static Font fontContentBoldS = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLD, Color.BLACK);
    public static Font fontContentArtS = FontFactory.getFont(FontFactory.HELVETICA, 9, Font.BOLDITALIC, Color.BLACK);

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {

        Rectangle rectangle = new Rectangle(20, 20, 20, 20);
        rectangle.rotate();
        Document document = new Document(PageSize.A4, 20, 20, 40, 20);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        
        try {
            PdfWriter writer = PdfWriter.getInstance(document, baos);
            HttpSession session = request.getSession(true);
            Vector vList = (Vector) session.getValue("SESS_INV_KOMIN_ALL");
            
            String IMAGE_PRINT_PATH_CRM = DbSystemProperty.getValueByName("IMAGE_PRINT_PATH_CRM");
            String pathLogo = IMAGE_PRINT_PATH_CRM + "btdc-logo-black-white.gif";
            Image logo = null;

            try {
                logo = Image.getInstance(pathLogo);
            } catch (Exception ex) {
                System.out.println(ex.toString());
            }
            
            document.open();
            for(int i=0; i<vList.size(); i++) {
                if(i != 0) document.newPage();
                InvoiceKomin invoiceKomin = (InvoiceKomin) vList.get(i);
                document.add(getInvoice(document, invoiceKomin, logo));
            }

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

    private static Table getInvoice(Document document, InvoiceKomin invoiceKomin, Image logo)
            throws BadElementException, DocumentException {
        Table invoice = new Table(5);
        int[] colWidth = {6, 40, 31, 3, 20};
        invoice.setWidths(colWidth);
        invoice.setWidth(100);
        invoice.setCellpadding(1);
        invoice.setCellspacing(1);
        invoice.setBorderColor(whiteColor);
        
        if (logo != null) {
            logo.scalePercent(35);
            logo.setAbsolutePosition(20, 760);
            document.add(logo);
        }
        
        invoice.setDefaultCellBorder(Table.NO_BORDER);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultVerticalAlignment(Cell.ALIGN_MIDDLE);
        invoice.setDefaultRowspan(1);
        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase(invoiceKomin.getNamaBadan(), fontHeaderBU));
        invoice.addCell(new Phrase(invoiceKomin.getNamaKomersil(), fontHeader));
        invoice.addCell(new Phrase("", fontHeader));
        
        invoice.setDefaultColspan(5);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("I N V O I C E", fontHeaderBI));
        
        invoice.addCell(new Phrase("", fontHeader));
        
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("Kepada :", fontContentBold));
        
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase(invoiceKomin.getPNamaBadan(), fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.addCell(new Phrase("No. : ", fontContentBold));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase(invoiceKomin.getNomor(), fontContent));
        
        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContentBold));
        
        invoice.setDefaultCellBorder(Table.TOP|Table.RIGHT|Table.BOTTOM|Table.LEFT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("NO", fontContentBold));
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("URAIAN", fontContentBold));
        invoice.addCell(new Phrase("JUMLAH", fontContentBold));
        
        invoice.setDefaultCellBorder(Table.RIGHT|Table.LEFT);
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("1", fontContent));
        invoice.setDefaultColspan(2);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase(invoiceKomin.getInvoiceDesc(), fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.addCell(new Phrase(invoiceKomin.getMataUang(), fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase(JSPFormater.formatNumber(invoiceKomin.getTagihan(),"#,###.##"), fontContent));
        
        invoice.setDefaultCellBorder(Table.RIGHT|Table.LEFT);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.setDefaultColspan(1);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase(invoiceKomin.getPerhitungan(), fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("", fontContent));
        
        invoice.setDefaultCellBorder(Table.RIGHT|Table.LEFT);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.setDefaultColspan(1);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("", fontContent));
        
        invoice.setDefaultCellBorder(Table.RIGHT|Table.LEFT);
        invoice.setDefaultColspan(1);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("", fontContent));
        
        invoice.setDefaultCellBorder(Table.RIGHT|Table.LEFT);
        invoice.setDefaultColspan(1);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase("", fontContent));
        
        invoice.setDefaultCellBorder(Table.RIGHT|Table.BOTTOM|Table.LEFT);
        invoice.setDefaultColspan(1);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.LEFT|Table.BOTTOM);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT|Table.BOTTOM);
        invoice.addCell(new Phrase("", fontContent));
        
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("Sub Total", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.NO_BORDER);
        invoice.addCell(new Phrase(invoiceKomin.getMataUang(), fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase(JSPFormater.formatNumber(invoiceKomin.getTagihan(),"#,###.##"), fontContent));
        
        invoice.setDefaultCellBorder(Table.LEFT);
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("PPN (10%)", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.NO_BORDER);
        invoice.addCell(new Phrase(invoiceKomin.getMataUang(), fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT);
        invoice.addCell(new Phrase(JSPFormater.formatNumber((invoiceKomin.getTagihan()*0.1),"#,###.##"), fontContent));
        
        invoice.setDefaultCellBorder(Table.LEFT|Table.BOTTOM);
        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultColspan(1);
        invoice.setDefaultCellBorder(Table.RIGHT|Table.BOTTOM);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.addCell(new Phrase("-PPH 4(2) (10%)", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.BOTTOM);
        invoice.addCell(new Phrase(invoiceKomin.getMataUang(), fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT|Table.BOTTOM);
        invoice.addCell(new Phrase("("+JSPFormater.formatNumber((invoiceKomin.getTagihan()*0.1),"#,###.##")+")", fontContent));
        
        invoice.setDefaultColspan(3);
        invoice.setDefaultCellBorder(Table.RIGHT|Table.BOTTOM|Table.LEFT);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.addCell(new Phrase("T O T A L", fontContentBold));
        invoice.setDefaultColspan(1);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_RIGHT);
        invoice.setDefaultCellBorder(Table.BOTTOM);
        invoice.addCell(new Phrase(invoiceKomin.getMataUang(), fontContent));
        invoice.setDefaultCellBorder(Table.RIGHT|Table.BOTTOM);
        invoice.addCell(new Phrase(JSPFormater.formatNumber(invoiceKomin.getTagihan(),"#,###.##"), fontContent));
        
        invoice.setDefaultCellBorder(Table.NO_BORDER);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_LEFT);
        invoice.setDefaultColspan(1);
        invoice.addCell(new Phrase("Note :", fontContentS));
        invoice.setDefaultColspan(4);
        invoice.addCell(new Phrase("Jika pembayaran dilaksanakan setelah tanggal "+invoiceKomin.getInvoiceDueDate()+", maka akan dikenakan denda keterlambatan sampai pada saat pelunasan.", fontContentS));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomin.getInvoiceDate(), fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomin.getNamaBadan(), fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase("D I R E K S I", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(5);
        invoice.addCell(new Phrase("", fontContent));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultVerticalAlignment(Cell.ALIGN_BOTTOM);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomin.getTtdNama(), fontContentBold));

        invoice.setDefaultColspan(2);
        invoice.addCell(new Phrase("", fontContent));
        invoice.setDefaultVerticalAlignment(Cell.ALIGN_TOP);
        invoice.setDefaultHorizontalAlignment(Cell.ALIGN_CENTER);
        invoice.setDefaultColspan(3);
        invoice.addCell(new Phrase(invoiceKomin.getTtdJabatan(), fontContent));
        
        return invoice;
    }
}
