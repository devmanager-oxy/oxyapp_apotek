
package com.project.fms.reportform; 
 
import java.util.Date;
import com.project.main.entity.*;

public class RptFormatDetailCoa extends Entity { 

	private long rptFormatDetailId;
	private long coaId;
	
	private int isMinus;
	private long depId;
	private long depLevel1Id;
	private long depLevel2Id;
	private long depLevel3Id;
	private long depLevel4Id;
	private long depLevel5Id;

	public long getDepLevel5Id(){ 
		return depLevel5Id; 
	} 

	public void setDepLevel5Id(long depLevel5Id){ 
		this.depLevel5Id = depLevel5Id; 
	}
	
	public long getDepLevel4Id(){ 
		return depLevel4Id; 
	} 

	public void setDepLevel4Id(long depLevel4Id){ 
		this.depLevel4Id = depLevel4Id; 
	}
	
	public long getDepLevel3Id(){ 
		return depLevel3Id; 
	} 

	public void setDepLevel3Id(long depLevel3Id){ 
		this.depLevel3Id = depLevel3Id; 
	}
	
	public long getDepLevel2Id(){ 
		return depLevel2Id; 
	} 

	public void setDepLevel2Id(long depLevel2Id){ 
		this.depLevel2Id = depLevel2Id; 
	}
	
	public long getDepLevel1Id(){ 
		return depLevel1Id; 
	} 

	public void setDepLevel1Id(long depLevel1Id){ 
		this.depLevel1Id = depLevel1Id; 
	}
	
	public long getDepId(){ 
		return depId; 
	} 

	public void setDepId(long depId){ 
		this.depId = depId; 
	}
	
	public int getIsMinus(){ 
		return isMinus; 
	} 

	public void setIsMinus(int isMinus){ 
		this.isMinus = isMinus; 
	}

	public long getRptFormatDetailId(){ 
		return rptFormatDetailId; 
	} 

	public void setRptFormatDetailId(long rptFormatDetailId){ 
		this.rptFormatDetailId = rptFormatDetailId; 
	} 

	public long getCoaId(){ 
		return coaId; 
	} 

	public void setCoaId(long coaId){ 
		this.coaId = coaId; 
	} 

}
