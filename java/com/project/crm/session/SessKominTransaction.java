package com.project.crm.session;

import com.project.crm.report.RptKominTransaction;
import com.project.crm.sewa.DbSewaTanah;
import com.project.crm.sewa.DbSewaTanahInvoice;
import com.project.crm.sewa.SewaTanahInvoice;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.Gl;
import com.project.general.DbCurrency;
import com.project.general.DbCustomer;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import java.sql.ResultSet;
import java.util.Vector;

/**
 *
 * @author gwawan
 */
public class SessKominTransaction {
    
    public static Vector ListFPKomin(int month, int year, long oidSarana) {
        CONResultSet dbrs = null;
        Vector list = new Vector();
        
        try {
            String sql = "SELECT sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NO_FP]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]
                    + ", cus." + DbCustomer.colNames[DbCustomer.COL_NAME]
                    + " FROM " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE+" sti"
                    + " INNER JOIN " + DbSewaTanah.DB_CRM_SEWA_TANAH+" st"
                    + " ON sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_ID]
                    + " = st." + DbSewaTanah.colNames[DbSewaTanah.COL_SEWA_TANAH_ID]
                    + " INNER JOIN " + DbCustomer.DB_CUSTOMER+" cus"
                    + " ON st." + DbSewaTanah.colNames[DbSewaTanah.COL_CUSTOMER_ID]
                    + " = cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]
                    + " WHERE sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE] + " = " + DbSewaTanahInvoice.TYPE_INV_KOMIN;
            
            String where = " AND (MONTH("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + month
                    + " AND " + "YEAR(" + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + year +")";
            
            if(oidSarana != 0) where += " AND cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + oidSarana;
            
            sql += where;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                RptKominTransaction objRptKominTransaction = new RptKominTransaction();
                objRptKominTransaction.setSewaTanahInvoiceId(rs.getLong("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]));
                objRptKominTransaction.setInvoiceNumber(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]));
                objRptKominTransaction.setNoFp(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NO_FP]));
                objRptKominTransaction.setJumlahKomin(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]));
                objRptKominTransaction.setCustomerName(rs.getString("cus."+DbCustomer.colNames[DbCustomer.COL_NAME]));
                
                list.add(objRptKominTransaction);
            }
            
            return list;
        } catch(Exception e) {
            System.out.println("Error ListFPKomin : "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static void UpdateFPKomin(long oidKomin, String noFp) {
        try {
            SewaTanahInvoice objSewaTanahInvoice = new SewaTanahInvoice();
            objSewaTanahInvoice = DbSewaTanahInvoice.fetchExc(oidKomin);
            objSewaTanahInvoice.setNoFp(noFp);
            DbSewaTanahInvoice.updateExc(objSewaTanahInvoice);
        } catch(Exception e) {
            System.out.println("Error UpdateFPKomin : "+e.toString());
        }
    }
    
    public static Vector listDenda(int month, int year, long oidSarana){
        CONResultSet dbrs = null;
        Vector list = new Vector();
        
        try {
            String sql = "SELECT " + "sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JATUH_TEMPO]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TOTAL_DENDA]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_DIAKUI]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_APPROVE_ID]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_APPROVE_DATE]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_KETERANGAN]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_CLIENT_NAME]
                    + ", sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_CLIENT_POSITION]
                    + ", cur." + DbCurrency.colNames[DbCurrency.COL_CURRENCY_CODE]
                    + ", cus." + DbCustomer.colNames[DbCustomer.COL_NAME]
                    + " FROM " + DbSewaTanahInvoice.DB_CRM_SEWA_TANAH_INVOICE + " sti"
                    + " INNER JOIN " + DbSewaTanah.DB_CRM_SEWA_TANAH + " st"
                    + " ON sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_ID]
                    + " = st." + DbSewaTanah.colNames[DbSewaTanah.COL_SEWA_TANAH_ID]
                    + " INNER JOIN " + DbCustomer.DB_CUSTOMER + " cus"
                    + " ON st." + DbSewaTanah.colNames[DbSewaTanah.COL_CUSTOMER_ID]
                    + " = cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID]
                    + " INNER JOIN " + DbCurrency.DB_CURRENCY + " cur"
                    + " ON sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_CURRENCY_ID]
                    +" = cur." + DbCurrency.colNames[DbCurrency.COL_CURRENCY_ID]
                    + " WHERE sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE] + " = " + DbSewaTanahInvoice.TYPE_INV_KOMIN;
            
            String where = " AND (MONTH("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + month
                    + " AND " + "YEAR(" + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + year +")";
            
            if(oidSarana != 0) where += " AND cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + oidSarana;
            
            sql += where;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                RptKominTransaction objRptKominTransaction = new RptKominTransaction();
                
                objRptKominTransaction.setSewaTanahInvoiceId(rs.getLong("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]));
                objRptKominTransaction.setJatuhTempo(rs.getDate("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JATUH_TEMPO]));
                objRptKominTransaction.setInvoiceNumber(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]));
                objRptKominTransaction.setJumlahKomin(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]));
                objRptKominTransaction.setTotalDenda(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TOTAL_DENDA]));
                objRptKominTransaction.setStatusPembayaran(DbSewaTanahInvoice.statusStr[rs.getInt("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN])]);
                objRptKominTransaction.setCurrencyCode(rs.getString("cur."+DbCurrency.colNames[DbCurrency.COL_CURRENCY_CODE]));
                objRptKominTransaction.setCustomerName(rs.getString("cus."+DbCustomer.colNames[DbCustomer.COL_NAME]));
                objRptKominTransaction.setDendaDiakui(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_DIAKUI]));
                objRptKominTransaction.setDendaApproveId(rs.getLong("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_APPROVE_ID]));
                objRptKominTransaction.setDendaApproveDate(rs.getDate("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_APPROVE_DATE]));
                objRptKominTransaction.setDendaKeterangan(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_KETERANGAN]));
                objRptKominTransaction.setDendaClientName(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_CLIENT_NAME]));
                objRptKominTransaction.setDendaClientPosition(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_CLIENT_POSITION]));
                
                list.add(objRptKominTransaction);
            }
            
            return list;
        } catch(Exception e) {
            System.out.println("Error when listDenda(#,#,#)" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    
    public static void postingKominDenda(long transaksiOID, int status){
        
        try {
            
            SewaTanahInvoice sewaTanahInvoice = new SewaTanahInvoice();
            
            //LimbahTransaction limbahTransaction = new LimbahTransaction();
            sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(transaksiOID);
            
            //limbahTransaction = DbLimbahTransaction.fetchExc(transaksiOID);

            System.out.println("Masuk >>>> status denda : " + status);

            sewaTanahInvoice.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbSewaTanahInvoice.postJournalDenda(sewaTanahInvoice);
            
            if (ok) {
                
                DbSewaTanahInvoice.updateExc(sewaTanahInvoice);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + sewaTanahInvoice.getNumber() + "D')";
                
                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging denda	
                SessReceivable.prosesInsertAgingDenda(sewaTanahInvoice, gl);
            }

        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
    }
    
    public static boolean postKominDenda(long transaksiOID, int status){
        
        try {
            
            SewaTanahInvoice sewaTanahInvoice = new SewaTanahInvoice();
            
            //LimbahTransaction limbahTransaction = new LimbahTransaction();
            sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(transaksiOID);
            
            //limbahTransaction = DbLimbahTransaction.fetchExc(transaksiOID);

            System.out.println("Masuk >>>> status denda : " + status);

            sewaTanahInvoice.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbSewaTanahInvoice.postJournalDenda(sewaTanahInvoice);
            
            if(ok == false){
                return false;
            }
            
            if (ok) {
                
                DbSewaTanahInvoice.updateExc(sewaTanahInvoice);

                // proses pencarian journal
                String where = "(" //+ DbGl.colNames[DbGl.COL_REF_NUMBER] + " ='" + limbahTransaction.getInvoiceNumber() + "' or " +
                        + DbGl.colNames[DbGl.COL_JOURNAL_NUMBER] + " ='" + sewaTanahInvoice.getNumber() + "D')";
                
                Vector vect = DbGl.list(0, 0, where, "");
                Gl gl = new Gl();
                if (vect.size() > 0) {
                    gl = (Gl) vect.get(0);
                }

                //===== >>> : proses insert aging denda	
                SessReceivable.prosesInsertAgingDenda(sewaTanahInvoice, gl);
                
                return true;
            }

        } catch (Exception e) {
            System.out.println("ERR >> : " + e.toString());
        }
        
        return false;
    }
    
}
