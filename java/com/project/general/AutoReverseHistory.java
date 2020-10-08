/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.general;

import com.project.main.entity.Entity;
import java.util.Date;

/**
 *
 * @author gwawan
 */
public class AutoReverseHistory extends Entity {
    private long glId = 0;
    private Date glDate = new Date();
    private long exchangeRateId = 0;
    private long coaId = 0;

    public long getCoaId() {
        return coaId;
    }

    public void setCoaId(long coaId) {
        this.coaId = coaId;
    }

    public long getExchangeRateId() {
        return exchangeRateId;
    }

    public void setExchangeRateId(long exchangeRateId) {
        this.exchangeRateId = exchangeRateId;
    }

    public Date getGlDate() {
        return glDate;
    }

    public void setGlDate(Date glDate) {
        this.glDate = glDate;
    }

    public long getGlId() {
        return glId;
    }

    public void setGlId(long glId) {
        this.glId = glId;
    }

}
