/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.interfaces;
import com.project.main.entity.Entity;

/**
 *
 * @author Roy Andika
 * @Desc Interface ini bertujuan untuk melakukan proses insert & update 
 * data penerimaan ke Cash Receive
 */
public interface I_FmsCrmInsertUpdate {     
    public long insertBKM(Entity ent) throws Exception;
    public long updateBKM(Entity ent) throws Exception;
}
