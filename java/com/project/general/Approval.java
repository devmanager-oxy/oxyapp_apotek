/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;
import com.project.main.entity.*;

/**
 *
 * @author Tu Roy
 */
public class Approval extends Entity{
    
    private int type            = 0;
    private int urutan          = 0;
    private String keterangan  = "";
    private long employeeId;
    
    private double jumlahDari;
    private double jumlahSampai;
    
    private int urutanApproval;
    private String keteranganFooter = "";
        
    public String getKeteranganFooter() {
        return keteranganFooter;
    }

    public void setKeteranganFooter(String keteranganFooter) {
        this.keteranganFooter = keteranganFooter;
    }
    
    public int getUrutanApproval() {
        return urutanApproval;
    }

    public void setUrutanApproval(int urutanApproval) {
        this.urutanApproval = urutanApproval;
    }
    
    public double getJumlahSampai() {
        return jumlahSampai;
    }

    public void setJumlahSampai(double jumlahSampai) {
        this.jumlahSampai = jumlahSampai;
    }

    public double getJumlahDari() {
        return jumlahDari;
    }

    public void setJumlahDari(double jumlahDari) {
        this.jumlahDari = jumlahDari;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getUrutan() {
        return urutan;
    }

    public void setUrutan(int urutan) {
        this.urutan = urutan;
    }

    public String getKeterangan() {
        return keterangan;
    }

    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }

    public long getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(long employeeId) {
        this.employeeId = employeeId;
    }
    

}
