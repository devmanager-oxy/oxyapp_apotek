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
public class Document extends Entity{
    
    private String nameDocument = "";
    private int typeKaryawan;
    private int typePengusaha;
    private int typeProfesi;

    public String getNameDocument() {
        return nameDocument;
    }

    public void setNameDocument(String nameDocument) {
        this.nameDocument = nameDocument;
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

    public int getTypeKaryawan() {
        return typeKaryawan;
    }

    public void setTypeKaryawan(int typeKaryawan) {
        this.typeKaryawan = typeKaryawan;
    }

}
