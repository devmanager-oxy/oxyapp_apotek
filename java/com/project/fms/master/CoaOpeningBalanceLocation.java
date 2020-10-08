/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.fms.master;
import com.project.main.entity.*;
/**
 *
 * @author Roy Andika
 */
public class CoaOpeningBalanceLocation extends Entity {
    
    private long coaId = 0;
    private long periodeId = 0;
    private double openingBalance = 0;
    private long segment1Id = 0;
    
    private long coaLevel1Id = 0;
    private long coaLevel2Id = 0;
    private long coaLevel3Id = 0;
    private long coaLevel4Id = 0;
    private long coaLevel5Id = 0;
    private long coaLevel6Id = 0;
    private long coaLevel7Id = 0;

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public long getPeriodeId() {
        return periodeId;
    }

    public void setPeriodeId(long periodeId) {
        this.periodeId = periodeId;
    }

    public double getOpeningBalance() {
        return openingBalance;
    }

    public void setOpeningBalance(double openingBalance) {
        this.openingBalance = openingBalance;
    }

    public long getSegment1Id() {
        return segment1Id;
    }

    public void setSegment1Id(long segment1Id) {
        this.segment1Id = segment1Id;
    }

    public long getCoaLevel1Id() {
        return coaLevel1Id;
    }

    public void setCoaLevel1Id(long coaLevel1Id) {
        this.coaLevel1Id = coaLevel1Id;
    }

    public long getCoaLevel2Id() {
        return coaLevel2Id;
    }

    public void setCoaLevel2Id(long coaLevel2Id) {
        this.coaLevel2Id = coaLevel2Id;
    }

    public long getCoaLevel3Id() {
        return coaLevel3Id;
    }

    public void setCoaLevel3Id(long coaLevel3Id) {
        this.coaLevel3Id = coaLevel3Id;
    }

    public long getCoaLevel4Id() {
        return coaLevel4Id;
    }

    public void setCoaLevel4Id(long coaLevel4Id) {
        this.coaLevel4Id = coaLevel4Id;
    }

    public long getCoaLevel5Id() {
        return coaLevel5Id;
    }

    public void setCoaLevel5Id(long coaLevel5Id) {
        this.coaLevel5Id = coaLevel5Id;
    }

    public long getCoaLevel6Id() {
        return coaLevel6Id;
    }

    public void setCoaLevel6Id(long coaLevel6Id) {
        this.coaLevel6Id = coaLevel6Id;
    }

    public long getCoaLevel7Id() {
        return coaLevel7Id;
    }

    public void setCoaLevel7Id(long coaLevel7Id) {
        this.coaLevel7Id = coaLevel7Id;
    }
}
