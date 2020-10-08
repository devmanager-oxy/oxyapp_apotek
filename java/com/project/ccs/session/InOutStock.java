/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.project.ccs.session;

/**
 *
 * @author Roy
 */
public class InOutStock {

    private long itemId= 0;
    private double begining = 0;
    private double in = 0;
    private double out = 0;
    private double opname = 0;

    public long getItemId() {
        return itemId;
    }

    public void setItemId(long itemId) {
        this.itemId = itemId;
    }

    public double getBegining() {
        return begining;
    }

    public void setBegining(double begining) {
        this.begining = begining;
    }

    public double getIn() {
        return in;
    }

    public void setIn(double in) {
        this.in = in;
    }

    public double getOut() {
        return out;
    }

    public void setOut(double out) {
        this.out = out;
    }

    public double getOpname() {
        return opname;
    }

    public void setOpname(double opname) {
        this.opname = opname;
    }
    
    
}
