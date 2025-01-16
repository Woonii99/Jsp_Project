package com.sist.web.model;

import java.io.Serializable;

public class FreeCom implements Serializable
{
	private static final long serialVersionUID = 1L;
	private long freeComSeq;
	private long freeBbsSeq;
	private String userId;
	private String freeComContent;
	private String freeComStatus;
	private String regDate;
	
	public long getFreeComSeq() {
		return freeComSeq;
	}
	public void setFreeComSeq(long freeComSeq) {
		this.freeComSeq = freeComSeq;
	}
	public long getFreeBbsSeq() {
		return freeBbsSeq;
	}
	public void setFreeBbsSeq(long freeBbsSeq) {
		this.freeBbsSeq = freeBbsSeq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getFreeComContent() {
		return freeComContent;
	}
	public void setFreeComContent(String freeComContent) {
		this.freeComContent = freeComContent;
	}
	public String getFreeComStatus() {
		return freeComStatus;
	}
	public void setFreeComStatus(String freeComStatus) {
		this.freeComStatus = freeComStatus;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
	public FreeCom()
	{
		setFreeComSeq(0);
		setFreeBbsSeq(0);
		setUserId("");
		setFreeComContent("");
		setFreeComStatus("");
		setRegDate("");
	}
}
