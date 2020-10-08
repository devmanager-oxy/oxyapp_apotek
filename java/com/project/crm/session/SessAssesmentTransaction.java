package com.project.crm.session;

import com.project.crm.report.RptAssesmentTransaction;
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
public class SessAssesmentTransaction {
    
    public static Vector ListFPAssesment(int month, int year, long oidSarana) {
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
                    + " WHERE sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE] + " = " + DbSewaTanahInvoice.TYPE_INV_ASSESMENT;
            
            String where = " AND (MONTH("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + month
                    + " AND " + "YEAR(" + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + year +")";
            
            if(oidSarana != 0) where += " AND cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + oidSarana;
            
            sql += where;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                RptAssesmentTransaction objRptAssesmentTransaction = new RptAssesmentTransaction();
                objRptAssesmentTransaction.setSewaTanahInvoiceId(rs.getLong("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]));
                objRptAssesmentTransaction.setInvoiceNumber(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]));
                objRptAssesmentTransaction.setNoFp(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NO_FP]));
                objRptAssesmentTransaction.setJumlahAssesment(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]));
                objRptAssesmentTransaction.setCustomerName(rs.getString("cus."+DbCustomer.colNames[DbCustomer.COL_NAME]));
                
                list.add(objRptAssesmentTransaction);
            }
            
            return list;
        } catch(Exception e) {
            System.out.println("Error ListFPAssesment : "+e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
    public static void UpdateFPAssesment(long oidKomper, String noFp) {
        try {
            SewaTanahInvoice objSewaTanahInvoice = new SewaTanahInvoice();
            objSewaTanahInvoice = DbSewaTanahInvoice.fetchExc(oidKomper);
            objSewaTanahInvoice.setNoFp(noFp);
            DbSewaTanahInvoice.updateExc(objSewaTanahInvoice);
        } catch(Exception e) {
            System.out.println("Error UpdateFPAssesment : "+e.toString());
        }
    }
    
    public static Vector listDenda(int month, int year, long oidSarana) {
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
                    + " WHERE sti." + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TYPE] + 
                    " = " + DbSewaTanahInvoice.TYPE_INV_ASSESMENT;
            
            String where = " AND (MONTH("+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + month
                    + " AND " + "YEAR(" + DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TANGGAL] + ")=" + year +")";
            
            if(oidSarana != 0) where += " AND cus." + DbCustomer.colNames[DbCustomer.COL_CUSTOMER_ID] + " = " + oidSarana;
            
            sql += where;
            
            dbrs = CONHandler.execQueryResult(sql);
            ResultSet rs = dbrs.getResultSet();
            
            while(rs.next()) {
                RptAssesmentTransaction objRptAssesmentTransaction = new RptAssesmentTransaction();
                
                objRptAssesmentTransaction.setSewaTanahInvoiceId(rs.getLong("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_SEWA_TANAH_INVOICE_ID]));
                objRptAssesmentTransaction.setJatuhTempo(rs.getDate("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JATUH_TEMPO]));
                objRptAssesmentTransaction.setInvoiceNumber(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_NUMBER]));
                objRptAssesmentTransaction.setJumlahAssesment(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_JUMLAH]));
                objRptAssesmentTransaction.setTotalDenda(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_TOTAL_DENDA]));
                objRptAssesmentTransaction.setStatusPembayaran(DbSewaTanahInvoice.statusStr[rs.getInt("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_STATUS_PEMBAYARAN])]);
                objRptAssesmentTransaction.setCurrencyCode(rs.getString("cur."+DbCurrency.colNames[DbCurrency.COL_CURRENCY_CODE]));
                objRptAssesmentTransaction.setCustomerName(rs.getString("cus."+DbCustomer.colNames[DbCustomer.COL_NAME]));
                objRptAssesmentTransaction.setDendaDiakui(rs.getDouble("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_DIAKUI]));
                objRptAssesmentTransaction.setDendaApproveId(rs.getLong("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_APPROVE_ID]));
                objRptAssesmentTransaction.setDendaApproveDate(rs.getDate("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_APPROVE_DATE]));
                objRptAssesmentTransaction.setDendaKeterangan(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_KETERANGAN]));
                objRptAssesmentTransaction.setDendaClientName(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_CLIENT_NAME]));
                objRptAssesmentTransaction.setDendaClientPosition(rs.getString("sti."+DbSewaTanahInvoice.colNames[DbSewaTanahInvoice.COL_DENDA_CLIENT_POSITION]));
                
                list.add(objRptAssesmentTransaction);
            }
            
            return list;
        } catch(Exception e) {
            System.out.println("Error when listDenda(#,#,#)" + e.toString());
        } finally {
            CONResultSet.close(dbrs);
        }
        return null;
    }
    
     public static void postingDendaAssesment(long transaksiOID, int status){
        
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
     
     
     public static boolean postDendaAssesment(long transaksiOID, int status){
        
        try {
            
            SewaTanahInvoice sewaTanahInvoice = new SewaTanahInvoice();
            
            //LimbahTransaction limbahTransaction = new LimbahTransaction();
            sewaTanahInvoice = DbSewaTanahInvoice.fetchExc(transaksiOID);
            
            //limbahTransaction = DbLimbahTransaction.fetchExc(transaksiOID);

            System.out.println("Masuk >>>> status denda : " + status);

            sewaTanahInvoice.setDendaPostStatus(status);

            // update status transaksi
            boolean ok = DbSewaTanahInvoice.postJournalDendaAssesment(sewaTanahInvoice);            
            
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
