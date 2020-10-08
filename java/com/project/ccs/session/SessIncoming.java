/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

import com.project.ccs.postransaction.receiving.DbReceive;
import com.project.main.db.CONHandler;
import com.project.main.db.CONResultSet;
import com.project.util.JSPFormater;
import java.util.Date;

/**
 *
 * @author Roy
 */
public class SessIncoming {
    
    public static long updateChecked(long recId,long userId){
        CONResultSet dbrs = null;
        try{
            String sql = "update "+DbReceive.DB_RECEIVE+" set "+DbReceive.colNames[DbReceive.COL_APPROVAL_2]+" = "+userId+","+DbReceive.colNames[DbReceive.COL_APPROVAL_2_DATE]+" = '"+JSPFormater.formatDate(new Date(),"yyyy-MM-dd HH:mm:dd")+"' where "+
                    DbReceive.colNames[DbReceive.COL_RECEIVE_ID]+recId;
            CONHandler.execUpdate(sql);
        }catch(Exception e){        
        }finally{
            CONResultSet.close(dbrs);
        }
        return 0;
    }

}
