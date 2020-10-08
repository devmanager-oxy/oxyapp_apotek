/*
 * RptPortofolioL.java
 *
 * Created on September 24, 2009, 11:54 AM
 */

package com.project.fms.report;

import com.project.main.entity.*;
import java.util.Date;

/**
 *
 * @author  Kyo
 */
public class RptPortofolioL extends Entity {
    
    
    private String code;
    private String name;
    private double targetLaba;
    private double targetLabaSd;
    private double targetLabaBulanIni;
    private double pdptSd;
    private double biayaSd;
    private double labaSd;
    private double persenLabaSd;
    private double pdpt;
    private double biaya;
    private double laba;
    private double persenLaba;
    private String keterangan;
    private double targetLabaBulanIni2;
    private double tTargetLaba;
    private double tTargetLabaBulanIni;
    private double ttTargetLabaSd;
    private double ttTargetLabaBulanIni2;
    private double ttLaba;
    private double ttLabaSd;
    private double ttPdpt;
    private double ttBiaya;
    private double ttBiayaSd;
    private double ttPdptSd;
    private double ttPersenLaba;
    private double ttPersenLabaSd;
    private int type;
    private int types;
    
    /** Creates a new instance of RptPortofolioL */
    public RptPortofolioL() {
    }
    
    /**
     * Getter for property code.
     * @return Value of property code.
     */
    public String getCode() {
        return this.code;
    }
    
    /**
     * Setter for property code.
     * @param code New value of property code.
     */
    public void setCode(String code) {
        this.code = code;
    }
    
    /**
     * Getter for property name.
     * @return Value of property name.
     */
    public String getName() {
        return this.name;
    }
    
    /**
     * Setter for property name.
     * @param name New value of property name.
     */
    public void setName(String name) {
        this.name = name;
    }
    
    /**
     * Getter for property targetLaba.
     * @return Value of property targetLaba.
     */
    public double getTargetLaba() {
        return this.targetLaba;
    }
    
    /**
     * Setter for property targetLaba.
     * @param targetLaba New value of property targetLaba.
     */
    public void setTargetLaba(double targetLaba) {
        this.targetLaba = targetLaba;
    }
    
    /**
     * Getter for property targetLabaSd.
     * @return Value of property targetLabaSd.
     */
    public double getTargetLabaSd() {
        return this.targetLabaSd;
    }
    
    /**
     * Setter for property targetLabaSd.
     * @param targetLabaSd New value of property targetLabaSd.
     */
    public void setTargetLabaSd(double targetLabaSd) {
        this.targetLabaSd = targetLabaSd;
    }
    
    /**
     * Getter for property targetLabaBulanIni.
     * @return Value of property targetLabaBulanIni.
     */
    public double getTargetLabaBulanIni() {
        return this.targetLabaBulanIni;
    }
    
    /**
     * Setter for property targetLabaBulanIni.
     * @param targetLabaBulanIni New value of property targetLabaBulanIni.
     */
    public void setTargetLabaBulanIni(double targetLabaBulanIni) {
        this.targetLabaBulanIni = targetLabaBulanIni;
    }
    
    /**
     * Getter for property pdptSd.
     * @return Value of property pdptSd.
     */
    public double getPdptSd() {
        return this.pdptSd;
    }
    
    /**
     * Setter for property pdptSd.
     * @param pdptSd New value of property pdptSd.
     */
    public void setPdptSd(double pdptSd) {
        this.pdptSd = pdptSd;
    }
    
    /**
     * Getter for property biayaSd.
     * @return Value of property biayaSd.
     */
    public double getBiayaSd() {
        return this.biayaSd;
    }
    
    /**
     * Setter for property biayaSd.
     * @param biayaSd New value of property biayaSd.
     */
    public void setBiayaSd(double biayaSd) {
        this.biayaSd = biayaSd;
    }
    
    /**
     * Getter for property labaSd.
     * @return Value of property labaSd.
     */
    public double getLabaSd() {
        return this.labaSd;
    }
    
    /**
     * Setter for property labaSd.
     * @param labaSd New value of property labaSd.
     */
    public void setLabaSd(double labaSd) {
        this.labaSd = labaSd;
    }
    
    /**
     * Getter for property persenLabaSd.
     * @return Value of property persenLabaSd.
     */
    public double getPersenLabaSd() {
        return this.persenLabaSd;
    }
    
    /**
     * Setter for property persenLabaSd.
     * @param persenLabaSd New value of property persenLabaSd.
     */
    public void setPersenLabaSd(double persenLabaSd) {
        this.persenLabaSd = persenLabaSd;
    }
    
    /**
     * Getter for property pdpt.
     * @return Value of property pdpt.
     */
    public double getPdpt() {
        return this.pdpt;
    }
    
    /**
     * Setter for property pdpt.
     * @param pdpt New value of property pdpt.
     */
    public void setPdpt(double pdpt) {
        this.pdpt = pdpt;
    }
    
    /**
     * Getter for property biaya.
     * @return Value of property biaya.
     */
    public double getBiaya() {
        return this.biaya;
    }
    
    /**
     * Setter for property biaya.
     * @param biaya New value of property biaya.
     */
    public void setBiaya(double biaya) {
        this.biaya = biaya;
    }
    
    /**
     * Getter for property laba.
     * @return Value of property laba.
     */
    public double getLaba() {
        return this.laba;
    }
    
    /**
     * Setter for property laba.
     * @param laba New value of property laba.
     */
    public void setLaba(double laba) {
        this.laba = laba;
    }
    
    /**
     * Getter for property persenLaba.
     * @return Value of property persenLaba.
     */
    public double getPersenLaba() {
        return this.persenLaba;
    }
    
    /**
     * Setter for property persenLaba.
     * @param persenLaba New value of property persenLaba.
     */
    public void setPersenLaba(double persenLaba) {
        this.persenLaba = persenLaba;
    }
    
    /**
     * Getter for property keterangan.
     * @return Value of property keterangan.
     */
    public String getKeterangan() {
        return this.keterangan;
    }
    
    /**
     * Setter for property keterangan.
     * @param keterangan New value of property keterangan.
     */
    public void setKeterangan(String keterangan) {
        this.keterangan = keterangan;
    }
    
    /**
     * Getter for property targetLabaBulanIni2.
     * @return Value of property targetLabaBulanIni2.
     */
    public double getTargetLabaBulanIni2() {
        return this.targetLabaBulanIni2;
    }
    
    /**
     * Setter for property targetLabaBulanIni2.
     * @param targetLabaBulanIni2 New value of property targetLabaBulanIni2.
     */
    public void setTargetLabaBulanIni2(double targetLabaBulanIni2) {
        this.targetLabaBulanIni2 = targetLabaBulanIni2;
    }
    
    /**
     * Getter for property tTargetLaba.
     * @return Value of property tTargetLaba.
     */
    public double getTtTargetLaba() {
        return this.tTargetLaba;
    }
    
    /**
     * Setter for property tTargetLaba.
     * @param tTargetLaba New value of property tTargetLaba.
     */
    public void setTtTargetLaba(double tTargetLaba) {
        this.tTargetLaba = tTargetLaba;
    }
    
    /**
     * Getter for property tTargetLabaBulanIni.
     * @return Value of property tTargetLabaBulanIni.
     */
    public double getTtTargetLabaBulanIni() {
        return this.tTargetLabaBulanIni;
    }
    
    /**
     * Setter for property tTargetLabaBulanIni.
     * @param tTargetLabaBulanIni New value of property tTargetLabaBulanIni.
     */
    public void setTtTargetLabaBulanIni(double tTargetLabaBulanIni) {
        this.tTargetLabaBulanIni = tTargetLabaBulanIni;
    }
    
    /**
     * Getter for property ttTargetLabaSd.
     * @return Value of property ttTargetLabaSd.
     */
    public double getTtTargetLabaSd() {
        return this.ttTargetLabaSd;
    }
    
    /**
     * Setter for property ttTargetLabaSd.
     * @param ttTargetLabaSd New value of property ttTargetLabaSd.
     */
    public void setTtTargetLabaSd(double ttTargetLabaSd) {
        this.ttTargetLabaSd = ttTargetLabaSd;
    }
    
    /**
     * Getter for property ttTargetLabaBulanIni2.
     * @return Value of property ttTargetLabaBulanIni2.
     */
    public double getTtTargetLabaBulanIni2() {
        return this.ttTargetLabaBulanIni2;
    }
    
    /**
     * Setter for property ttTargetLabaBulanIni2.
     * @param ttTargetLabaBulanIni2 New value of property ttTargetLabaBulanIni2.
     */
    public void setTtTargetLabaBulanIni2(double ttTargetLabaBulanIni2) {
        this.ttTargetLabaBulanIni2 = ttTargetLabaBulanIni2;
    }
    
    /**
     * Getter for property ttLaba.
     * @return Value of property ttLaba.
     */
    public double getTtLaba() {
        return this.ttLaba;
    }
    
    /**
     * Setter for property ttLaba.
     * @param ttLaba New value of property ttLaba.
     */
    public void setTtLaba(double ttLaba) {
        this.ttLaba = ttLaba;
    }
    
    /**
     * Getter for property ttLabaSd.
     * @return Value of property ttLabaSd.
     */
    public double getTtLabaSd() {
        return this.ttLabaSd;
    }
    
    /**
     * Setter for property ttLabaSd.
     * @param ttLabaSd New value of property ttLabaSd.
     */
    public void setTtLabaSd(double ttLabaSd) {
        this.ttLabaSd = ttLabaSd;
    }
    
    /**
     * Getter for property ttPdpt.
     * @return Value of property ttPdpt.
     */
    public double getTtPdpt() {
        return this.ttPdpt;
    }
    
    /**
     * Setter for property ttPdpt.
     * @param ttPdpt New value of property ttPdpt.
     */
    public void setTtPdpt(double ttPdpt) {
        this.ttPdpt = ttPdpt;
    }
    
    /**
     * Getter for property ttHarga.
     * @return Value of property ttHarga.
     */
    public double getTtBiaya() {
        return this.ttBiaya;
    }
    
    /**
     * Setter for property ttHarga.
     * @param ttHarga New value of property ttHarga.
     */
    public void setTtBiaya(double ttBiaya) {
        this.ttBiaya = ttBiaya;
    }
    
    /**
     * Getter for property ttBiayaSd.
     * @return Value of property ttBiayaSd.
     */
    public double getTtBiayaSd() {
        return this.ttBiayaSd;
    }
    
    /**
     * Setter for property ttBiayaSd.
     * @param ttBiayaSd New value of property ttBiayaSd.
     */
    public void setTtBiayaSd(double ttBiayaSd) {
        this.ttBiayaSd = ttBiayaSd;
    }
    
    /**
     * Getter for property ttPdptSd.
     * @return Value of property ttPdptSd.
     */
    public double getTtPdptSd() {
        return this.ttPdptSd;
    }
    
    /**
     * Setter for property ttPdptSd.
     * @param ttPdptSd New value of property ttPdptSd.
     */
    public void setTtPdptSd(double ttPdptSd) {
        this.ttPdptSd = ttPdptSd;
    }
    
    /**
     * Getter for property ttPersenLaba.
     * @return Value of property ttPersenLaba.
     */
    public double getTtPersenLaba() {
        return this.ttPersenLaba;
    }
    
    /**
     * Setter for property ttPersenLaba.
     * @param ttPersenLaba New value of property ttPersenLaba.
     */
    public void setTtPersenLaba(double ttPersenLaba) {
        this.ttPersenLaba = ttPersenLaba;
    }
    
    /**
     * Getter for property ttPersenLabaSd.
     * @return Value of property ttPersenLabaSd.
     */
    public double getTtPersenLabaSd() {
        return this.ttPersenLabaSd;
    }
    
    /**
     * Setter for property ttPersenLabaSd.
     * @param ttPersenLabaSd New value of property ttPersenLabaSd.
     */
    public void setTtPersenLabaSd(double ttPersenLabaSd) {
        this.ttPersenLabaSd = ttPersenLabaSd;
    }
    
    /**
     * Getter for property type.
     * @return Value of property type.
     */
    public int getType() {
        return this.type;
    }
    
    /**
     * Setter for property type.
     * @param type New value of property type.
     */
    public void setType(int type) {
        this.type = type;
    }
    
    /**
     * Getter for property types.
     * @return Value of property types.
     */
    public int getTypes() {
        return this.types;
    }
    
    /**
     * Setter for property types.
     * @param types New value of property types.
     */
    public void setTypes(int types) {
        this.types = types;
    }
    
}
