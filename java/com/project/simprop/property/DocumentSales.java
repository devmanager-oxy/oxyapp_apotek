/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.project.simprop.property;

import com.project.main.entity.*;

/**
 *
 * @author Roy Andika
 */
public class DocumentSales extends Entity {

    private long salesDataId;
    private long documentId;
    private int typeKaryawan;
    private int typePengusaha;
    private int typeProfesi;

    public long getDocumentId() {
        return documentId;
    }

    public void setDocumentId(long documentId) {
        this.documentId = documentId;
    }

    public int getTypeKaryawan() {
        return typeKaryawan;
    }

    public void setTypeKaryawan(int typeKaryawan) {
        this.typeKaryawan = typeKaryawan;
    }

    public int getTypePengusaha() {
        return typePengusaha;
    }

    public void setTypePengusaha(int typePengusaha) {
        this.typePengusaha = typePengusaha;
    }

    public int getTypeProfesi() {
        return typeProfesi;
    }

    public void setTypeProfesi(int typeProfesi) {
        this.typeProfesi = typeProfesi;
    }

    public long getSalesDataId() {
        return salesDataId;
    }

    public void setSalesDataId(long salesDataId) {
        this.salesDataId = salesDataId;
    }

    
}
