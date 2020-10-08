
package com.project.general; 

import com.project.main.entity.*;
import java.util.Date;

public class Location extends Entity { 

	private String type = "";
	private String name = "";
	private String addressStreet = "";
	private String addressCountry = "";
	private String addressCity = "";
	private String telp = "";
	private String pic = "";
        /**
         * Holds value of property code.
         */
        private String code = "";
        /**
         * Holds value of property description.
         */
        private String description = "";
        
        private long coaArId = 0;
        
	private long coaApId = 0;
        
	private long coaPpnId = 0;
        
	private long coaPphId = 0;
        
	private long coaDiscountId = 0;
        
        private long coaSalesId = 0;
        
        private long coaProjectPPHPasal23Id = 0;
        
        private long coaProjectPPHPasal22Id = 0;
        
        private long locationIdRequest = 0;
        
        private String gol_price = "";        
        private String npwp = "";        
        private String prefixFakturPajak = "";   
        private String prefixFakturTransfer = "";
        private int aktifAutoOrder = 0;
        
        private Date dateStart;
        private int typeGrosir = 0;
        private int type24Hour = 0;
        private double amountTarget = 0;     
        private long coaApGrosirId = 0;
        
	public String getType(){ 
		return type; 
	} 

	public void setType(String type){ 
		if ( type == null ) {
			type = ""; 
		} 
		this.type = type; 
	} 

	public String getName(){ 
		return name; 
	} 

	public void setName(String name){ 
		if ( name == null ) {
			name = ""; 
		} 
		this.name = name; 
	} 

	public String getAddressStreet(){ 
		return addressStreet; 
	} 

	public void setAddressStreet(String addressStreet){ 
		if ( addressStreet == null ) {
			addressStreet = ""; 
		} 
		this.addressStreet = addressStreet; 
	} 

	public String getAddressCountry(){ 
		return addressCountry; 
	} 

	public void setAddressCountry(String addressCountry){ 
		if ( addressCountry == null ) {
			addressCountry = ""; 
		} 
		this.addressCountry = addressCountry; 
	} 

	public String getAddressCity(){ 
		return addressCity; 
	} 

	public void setAddressCity(String addressCity){ 
		if ( addressCity == null ) {
			addressCity = ""; 
		} 
		this.addressCity = addressCity; 
	} 

	public String getTelp(){ 
		return telp; 
	} 

	public void setTelp(String telp){ 
		if ( telp == null ) {
			telp = ""; 
		} 
		this.telp = telp; 
	} 

	public String getPic(){ 
		return pic; 
	} 

	public void setPic(String pic){ 
		if ( pic == null ) {
			pic = ""; 
		} 
		this.pic = pic; 
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
         * Getter for property description.
         * @return Value of property description.
         */
        public String getDescription() {
            return this.description;
        }
        
        /**
         * Setter for property description.
         * @param description New value of property description.
         */
        public void setDescription(String description) {
            this.description = description;
        }

    public long getCoaArId() {
        return coaArId;
    }

    public void setCoaArId(long coaArId) {
        this.coaArId = coaArId;
    }

    public long getCoaApId() {
        return coaApId;
    }

    public void setCoaApId(long coaApId) {
        this.coaApId = coaApId;
    }

    public long getCoaPpnId() {
        return coaPpnId;
    }

    public void setCoaPpnId(long coaPpnId) {
        this.coaPpnId = coaPpnId;
    }

    public long getCoaPphId() {
        return coaPphId;
    }

    public void setCoaPphId(long coaPphId) {
        this.coaPphId = coaPphId;
    }

    public long getCoaDiscountId() {
        return coaDiscountId;
    }

    public void setCoaDiscountId(long coaDiscountId) {
        this.coaDiscountId = coaDiscountId;
    }

    public long getCoaSalesId() {
        return coaSalesId;
    }

    public void setCoaSalesId(long coaSalesId) {
        this.coaSalesId = coaSalesId;
    }

    public long getCoaProjectPPHPasal23Id() {
        return coaProjectPPHPasal23Id;
    }

    public void setCoaProjectPPHPasal23Id(long coaProjectPPHPasal23Id) {
        this.coaProjectPPHPasal23Id = coaProjectPPHPasal23Id;
    }

    public long getCoaProjectPPHPasal22Id() {
        return coaProjectPPHPasal22Id;
    }

    public void setCoaProjectPPHPasal22Id(long coaProjectPPHPasal22Id) {
        this.coaProjectPPHPasal22Id = coaProjectPPHPasal22Id;
    }

    public long getLocationIdRequest() {
        return locationIdRequest;
    }

    public void setLocationIdRequest(long locationIdRequest) {
        this.locationIdRequest = locationIdRequest;
    }

    public String getGol_price() {
        return gol_price;
    }

    public void setGol_price(String gol_price) {
        this.gol_price = gol_price;
    }

    public String getNpwp() {
        return npwp;
    }

    public void setNpwp(String npwp) {
        this.npwp = npwp;
    }

    public String getPrefixFakturPajak() {
        return prefixFakturPajak;
    }

    public void setPrefixFakturPajak(String prefixFakturPajak) {
        this.prefixFakturPajak = prefixFakturPajak;
    }

    public String getPrefixFakturTransfer() {
        return prefixFakturTransfer;
    }

    public void setPrefixFakturTransfer(String prefixFakturTransfer) {
        this.prefixFakturTransfer = prefixFakturTransfer;
    }

    public int getAktifAutoOrder() {
        return aktifAutoOrder;
    }

    public void setAktifAutoOrder(int aktifAutoOrder) {
        this.aktifAutoOrder = aktifAutoOrder;
    }

    public Date getDateStart() {
        return dateStart;
    }

    public void setDateStart(Date dateStart) {
        this.dateStart = dateStart;
    }

    public int getTypeGrosir() {
        return typeGrosir;
    }

    public void setTypeGrosir(int typeGrosir) {
        this.typeGrosir = typeGrosir;
    }

    public int getType24Hour() {
        return type24Hour;
    }

    public void setType24Hour(int type24Hour) {
        this.type24Hour = type24Hour;
    }

    public double getAmountTarget() {
        return amountTarget;
    }

    public void setAmountTarget(double amountTarget) {
        this.amountTarget = amountTarget;
    }

    public long getCoaApGrosirId() {
        return coaApGrosirId;
    }

    public void setCoaApGrosirId(long coaApGrosirId) {
        this.coaApGrosirId = coaApGrosirId;
    }
}
