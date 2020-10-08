/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.session;

import com.gargoylesoftware.htmlunit.javascript.host.Location;
import com.project.I_Project;
import com.project.ccs.posmaster.ItemGroup;
import com.project.ccs.posmaster.ItemMaster;
import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.ccs.postransaction.receiving.DbReceiveItem;
import com.project.ccs.postransaction.receiving.Receive;
import com.project.ccs.postransaction.receiving.ReceiveItem;
import com.project.fms.master.Coa;
import com.project.fms.master.DbCoa;
import com.project.fms.master.DbPeriode;
import com.project.fms.master.DbSegmentDetail;
import com.project.fms.master.Periode;
import com.project.fms.master.SegmentDetail;
import com.project.fms.transaction.DbGl;
import com.project.fms.transaction.QrInvoice;
import com.project.general.Company;
import com.project.general.DbCompany;
import com.project.general.DbExchangeRate;
import com.project.general.DbLocation;
import com.project.general.ExchangeRate;
import com.project.system.DbSystemProperty;
import java.util.Date;
import java.util.Vector;

/**
 *
 * @author Roy
 */
public class SessReceiveJournal {

    public static long journalCleareance(long receiveId){
        Receive cr = new Receive();
        try{
            cr = DbReceive.fetchExc(receiveId);
            if(cr.getOID() != 0){
                Company comp = DbCompany.getCompany();
                ExchangeRate er = DbExchangeRate.getStandardRate();
                
                Periode p = new Periode();                
                try{              
                    p = DbPeriode.getPeriodByTransDate(cr.getApproval1Date());                                        
                }catch(Exception ex){}
                
                if(comp.getOID() == 0 || er.getOID() == 0 || p.getOID() == 0 || p.getStatus().compareTo(I_Project.STATUS_PERIOD_CLOSED) == 0){
                    return 0;
                }
                
                long coaApClereanceId = 0;
                Coa coaAp = new Coa();
                try{
                    coaApClereanceId = Long.parseLong(DbSystemProperty.getValueByName("OID_COA_AP_CLEREANCE"));
                    coaAp = DbCoa.fetchExc(coaApClereanceId);
                }catch(Exception e){}
                
                if(coaAp.getOID() == 0 ){
                    return 0;
                }                
                
                long segment1_id = 0;
                
                if (cr.getLocationId() != 0) {
                    String whereSd = DbSegmentDetail.colNames[DbSegmentDetail.COL_LOCATION_ID] + "=" + cr.getLocationId();
                    Vector segmentDt = DbSegmentDetail.list(0, 1, whereSd, null);
                    if (segmentDt != null && segmentDt.size() > 0) {
                        SegmentDetail sd = (SegmentDetail) segmentDt.get(0);
                        if (sd.getRefSegmentDetailId() != 0) {
                            segment1_id = sd.getRefSegmentDetailId();
                        } else {
                            segment1_id = sd.getOID();
                        }
                    }else{
                        return 0;
                    }
                }else{
                    return 0;
                }
                
                Vector vck = DbReceiveItem.list(0,0, DbReceiveItem.colNames[DbReceiveItem.COL_RECEIVE_ID]+"="+cr.getOID(), "");  
                
                if(vck != null && vck.size() > 0){
                    
                    for(int ick = 0 ; ick < vck.size(); ick++){
                        
                        ReceiveItem rick = (ReceiveItem)vck.get(ick);
                        ItemMaster imck = new ItemMaster();
                        ItemGroup igck = new ItemGroup();
                        
                        try{                                    
                            imck = QrInvoice.getItem(rick.getItemMasterId());                        
                            igck = QrInvoice.getGroup(imck.getItemGroupId());                               
                        }catch(Exception e){
                             System.out.println("[exception] "+e.toString());
                        }           
                        
                        Vector invCoack = new Vector();
                                    
                        if(imck.getNeedRecipe()==0){
                            invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountInv()+"'", "");                            
                            if(invCoack == null || invCoack.size() <= 0){                                
                                return 0;
                            }                            
                        }else{
                            if(igck.getAccountExpenseJasa()!=null && igck.getAccountExpenseJasa().length()>0){
                                invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountExpenseJasa()+"'", "");
                            }else{
                                invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountInv()+"'", "");
                            }
                            if (invCoack == null || invCoack.size() <= 0) {                                
                                return 0;
                            }                                                       
                        }
                    }
                }    
                
                if(cr.getOID()!=0 && cr.getStatus().equals(I_Project.DOC_STATUS_APPROVED)){
                    
                    Date approval1Date = cr.getApproval1Date();
                    long uid = cr.getApproval2();
                    if(cr.getApproval2Date() == null){
                        approval1Date = new Date();
                        uid = cr.getApproval2();
                    }
                    
                    long oid = DbGl.postJournalMain(p.getTableName(),cr.getCurrencyId(), approval1Date, cr.getCounter(), "CLR"+cr.getNumber(), cr.getPrefixNumber(), 
                        I_Project.JOURNAL_TYPE_AP_CLEREANCE, 
                        "Hutang sementara incoming "+cr.getNumber(), uid, "", cr.getOID(), "", cr.getDate(), p.getOID());  
                    
                    if(oid != 0){
                        if(vck != null && vck.size() > 0){     
                            double totalHutang = 0;
                            for(int ick = 0 ; ick < vck.size(); ick++){
                        
                                ReceiveItem rick = (ReceiveItem)vck.get(ick);
                                ItemMaster imck = new ItemMaster();
                                ItemGroup igck = new ItemGroup();
                                
                                try{                                    
                                    imck = QrInvoice.getItem(rick.getItemMasterId());                        
                                    igck = QrInvoice.getGroup(imck.getItemGroupId());                               
                                }catch(Exception e){
                                    System.out.println("[exception] "+e.toString());
                                }  
                                
                                Vector invCoack = new Vector();                                    
                                if(imck.getNeedRecipe()==0){
                                    invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountInv()+"'", "");                            
                                    if(invCoack == null || invCoack.size() <= 0){                                
                                        return 0;
                                    }                            
                                }else{
                                    if(igck.getAccountExpenseJasa()!=null && igck.getAccountExpenseJasa().length()>0){
                                        invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountExpenseJasa()+"'", "");
                                    }else{
                                        invCoack = DbCoa.list(0,0, DbCoa.colNames[DbCoa.COL_CODE]+"='"+igck.getAccountInv()+"'", "");
                                    }
                                    if (invCoack == null || invCoack.size() <= 0) {                                
                                        return 0;
                                    }                                                       
                                }
                                
                                Coa coa = new Coa();
                                if(invCoack!=null && invCoack.size()>0){
                                    coa = (Coa)invCoack.get(0);
                                }
                                totalHutang = totalHutang + rick.getTotalAmount();
                                if(rick.getTotalAmount() != 0){
                                    if(rick.getTotalAmount() > 0){
                                        DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coa.getOID(), 0, rick.getTotalAmount(),             
                                                rick.getTotalAmount(), comp.getBookingCurrencyId(), oid, "Persediaan barang "+igck.getName()+"/"+imck.getName(), 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0); //non departmenttal item, department id = 0                                           
                                    }else{
                                        DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coa.getOID(), (rick.getTotalAmount()*-1), 0,             
                                                (rick.getTotalAmount()*-1), comp.getBookingCurrencyId(), oid, "Persediaan barang "+igck.getName()+"/"+imck.getName(), 0,
                                                segment1_id, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0,
                                                0, 0, 0, 0); //non departmenttal item, department id = 0         
                                    }
                                }
                            }
                            
                            if(totalHutang != 0){
                                if(totalHutang > 0){
                                    DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coaAp.getOID(), totalHutang, 0,             
                                        totalHutang, comp.getBookingCurrencyId(), oid, "Hutang sementara incoming "+cr.getNumber(), 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); //non departmenttal item, department id = 0                                      
                                }else{
                                    DbGl.postJournalDetail(p.getTableName(),er.getValueIdr(), coaAp.getOID(), 0, (totalHutang*-1),             
                                        (totalHutang*-1), comp.getBookingCurrencyId(), oid, "Hutang sementara incoming "+cr.getNumber(), 0,
                                        segment1_id, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0,
                                        0, 0, 0, 0); //non departmenttal item, department id = 0  
                                }
                            }
                            SessOptimizedJournal.optimizeJournalGl(p, oid, "Purchase ("+cr.getNumber()+") ", "Purchase ("+cr.getNumber()+") ", 1); 
                        }
                        
                    }
                    return oid;
                }
            }
        }catch(Exception e){}
        
        return 0;
    }
    
    
}
