package com.sist.web.model;

import java.io.Serializable;

public class Paging implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	public long totalBlock; // 총 블록의 수
	public long currentBlock; // 현재 블록

	public long totalPage; // 총 페이지의 수
	public long currentPage; // 현재 페이지
	public long startPage; // 현재 블록의 startPage
	public long endPage; // 현재 블록의 endPage
	public long prevBlockPage; // 이전 블록의 endPage
	public long nextBlockPage; // 다음 블록의 startPage
	public int numOfPagePerBlock; // 블록당 페이지 수

	public long totalPost; // 총 게시물의 수
	public long startPost; // 현재 페이지 내에서의 시작 게시물의 rownum
	public long endPost; // 현재 페이지 내에서의 끝 게시물의 rownum
	public long postNumber; // 게시물 넘버링
	public int numOfPostPerPage; // 페이지당 게시물 수
	
	
	
	public long getTotalBlock() {
		return totalBlock;
	}

	public void setTotalBlock(long totalBlock) {
		this.totalBlock = totalBlock;
	}

	public long getCurrentBlock() {
		return currentBlock;
	}

	public void setCurrentBlock(long currentBlock) {
		this.currentBlock = currentBlock;
	}

	public long getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(long totalPage) {
		this.totalPage = totalPage;
	}

	public long getCurrentPage() {
		return currentPage;
	}

	public void setCurrentPage(long currentPage) {
		this.currentPage = currentPage;
	}

	public long getStartPage() {
		return startPage;
	}

	public void setStartPage(long startPage) {
		this.startPage = startPage;
	}

	public long getEndPage() {
		return endPage;
	}

	public void setEndPage(long endPage) {
		this.endPage = endPage;
	}

	public long getPrevBlockPage() {
		return prevBlockPage;
	}

	public void setPrevBlockPage(long prevBlockPage) {
		this.prevBlockPage = prevBlockPage;
	}

	public long getNextBlockPage() {
		return nextBlockPage;
	}

	public void setNextBlockPage(long nextBlockPage) {
		this.nextBlockPage = nextBlockPage;
	}

	public int getNumOfPagePerBlock() {
		return numOfPagePerBlock;
	}

	public void setNumOfPagePerBlock(int numOfPagePerBlock) {
		this.numOfPagePerBlock = numOfPagePerBlock;
	}

	public long getTotalPost() {
		return totalPost;
	}

	public void setTotalPost(long totalPost) {
		this.totalPost = totalPost;
	}

	public long getStartPost() {
		return startPost;
	}

	public void setStartPost(long startPost) {
		this.startPost = startPost;
	}

	public long getEndPost() {
		return endPost;
	}

	public void setEndPost(long endPost) {
		this.endPost = endPost;
	}

	public long getPostNumber() {
		return postNumber;
	}

	public void setPostNumber(long postNumber) {
		this.postNumber = postNumber;
	}

	public int getNumOfPostPerPage() {
		return numOfPostPerPage;
	}

	public void setNumOfPostPerPage(int numOfPostPerPage) {
		this.numOfPostPerPage = numOfPostPerPage;
	}

	public Paging(long totalPost, int numOfPagePerBlock, int numOfPostPerPage, long currentPage) {
		this.totalPost = totalPost;
		this.numOfPagePerBlock = numOfPagePerBlock;
		this.numOfPostPerPage = numOfPostPerPage;
		this.currentPage = currentPage;
		
		if(totalPost > 0) {
			pagingProc();
		}
	}

	public void pagingProc() {
		// Math.ceil과 정수론적으로 동치(올림)
		totalPage = ((totalPost - 1) / numOfPostPerPage) + 1;
		totalBlock = ((totalPage - 1) / numOfPagePerBlock) + 1;
		currentBlock = ((currentPage - 1) / numOfPagePerBlock) + 1;

		/**
		 * 직관적이긴 하지만 endPage가 totalPage보다는 클 수 없기때문에 startPage를 먼저 구하는 식으로 변경해야한다.
		 * endPage = currentBlock * numOfPagePerBlock; startPage = endPage -
		 * numOfPagePerBlock + 1;
		 */

		startPage = (currentBlock - 1) * numOfPagePerBlock + 1;
		endPage = (startPage + numOfPagePerBlock - 1 > totalPage) ? totalPage : startPage + numOfPagePerBlock - 1;
		prevBlockPage = (currentBlock > 1) ? startPage - 1 : -1;
		nextBlockPage = (currentBlock < totalBlock) ? endPage + 1 : -1;

		startPost = (currentPage - 1) * numOfPostPerPage + 1;
		endPost = (startPost + numOfPostPerPage - 1 > totalPost) ? totalPost : startPost + numOfPostPerPage - 1;

		// 총 게시물이 36개이고 현재 페이지가 2페이지라면 postNumber는 31(이전 페이지에서 36 35 34 33 32를 보여줬었음)
		postNumber = totalPost - (currentPage - 1) * numOfPostPerPage;
	}
}