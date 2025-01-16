package com.sist.web.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sist.web.db.DBManager;
import com.sist.web.model.FreeCom;

public class FreeComDao {
	private static Logger logger = LogManager.getLogger(FreeBbsDao.class);

	public static Logger getLogger() {return logger;}
	public static void setLogger(Logger logger) {FreeComDao.logger = logger;}

	// 게시물 천체댓글 조회
    public List<FreeCom> getCommentsByPostId(long freeBbsSeq)
    {
        List<FreeCom> comments = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        StringBuilder sb = new StringBuilder();
        sb.append("SELECT FREE_COM_SEQ, FREE_BBS_SEQ, USER_ID, FREE_COM_CONTENT, ")
          .append("FREE_COM_STATUS, REG_DATE ")
          .append("FROM (SELECT A.FREE_COM_SEQ, A.FREE_BBS_SEQ, A.USER_ID, ")
          .append("           	A.FREE_COM_CONTENT, A.FREE_COM_STATUS, A.REG_DATE, ")
          .append("           ROWNUM AS RNUM ")
          .append("    FROM FREE_COM A ")
          .append("    JOIN USERS B ON A.USER_ID = B.USER_ID ")
          .append("    WHERE A.FREE_COM_STATUS <> 'N' ")
          .append("      AND A.FREE_BBS_SEQ = ? ")
          .append("    ORDER BY A.FREE_COM_SEQ DESC) ");

        try {
            conn = DBManager.getConnection();
            ps = conn.prepareStatement(sb.toString());
            ps.setLong(1, freeBbsSeq); 
            rs = ps.executeQuery();

            while (rs.next()) 
            {
                FreeCom comment = new FreeCom();
                comment.setFreeComSeq(rs.getLong("FREE_COM_SEQ"));
                comment.setFreeBbsSeq(rs.getLong("FREE_BBS_SEQ"));
                comment.setUserId(rs.getString("USER_ID"));
                comment.setFreeComContent(rs.getString("FREE_COM_CONTENT"));
                comment.setFreeComStatus(rs.getString("FREE_COM_STATUS"));
                comment.setRegDate(rs.getString("REG_DATE"));
                comments.add(comment);
            }
        } 
        catch (SQLException e) 
        {
            logger.error("[FreeBbsDao]getCommentsByPostId SQLException", e);
        } 
        finally 
        {
            DBManager.close(rs, ps, conn);
        }
        
        return comments;
    }
    
    // 댓글 삽입
    public boolean freeComInsert(FreeCom freeCom) 
    {
        Connection conn = null;
        PreparedStatement ps = null;
        StringBuilder sb = new StringBuilder();
        
        sb.append("INSERT INTO FREE_COM (FREE_COM_SEQ, FREE_BBS_SEQ, USER_ID, FREE_COM_CONTENT, FREE_COM_STATUS, REG_DATE) ")
          .append("VALUES (FREE_COM_SEQ.NEXTVAL, ?, ?, ?, 'Y', SYSDATE) ");

        int cnt = 0;

        try 
        {
            conn = DBManager.getConnection();
            ps = conn.prepareStatement(sb.toString());
            ps.setLong(1, freeCom.getFreeBbsSeq());
            ps.setString(2, freeCom.getUserId());
            ps.setString(3, freeCom.getFreeComContent());
            cnt = ps.executeUpdate();
        }
        catch (SQLException e) 
        {
            logger.error("[FreeComDao]freeComInsert SQLException", e);
        }
        finally 
        {
            DBManager.close(ps, conn);
        }

        return (cnt == 1);
    }

    // 댓글 수정
    public boolean updateComment(FreeCom freeCom) 
    {
        Connection conn = null;
        PreparedStatement ps = null;
        StringBuilder sb = new StringBuilder();
        
        sb.append("UPDATE FREE_COM SET FREE_COM_CONTENT = ?, REG_DATE = SYSDATE WHERE FREE_COM_SEQ = ? ");

        int cnt = 0;

        try 
        {
            conn = DBManager.getConnection();
            ps = conn.prepareStatement(sb.toString());
            ps.setString(1, freeCom.getFreeComContent());
            ps.setLong(2, freeCom.getFreeComSeq());
            cnt = ps.executeUpdate();
        }
        catch (SQLException e) 
        {
            logger.error("[FreeComDao]updateComment SQLException", e);
        }
        finally 
        {
            DBManager.close(ps, conn);
        }

        return (cnt == 1);
    }

    // 댓글 삭제
    public boolean deleteComment(long freeComSeq) 
    {
        Connection conn = null;
        PreparedStatement ps = null;
        StringBuilder sb = new StringBuilder();
        
        sb.append("UPDATE FREE_COM SET FREE_COM_STATUS = 'N' WHERE FREE_COM_SEQ = ? ");

        int cnt = 0;

        try 
        {
            conn = DBManager.getConnection();
            ps = conn.prepareStatement(sb.toString());
            ps.setLong(1, freeComSeq);
            cnt = ps.executeUpdate();
        } 
        catch (SQLException e) 
        {
            logger.error("[FreeComDao]deleteComment SQLException", e);
        }
        finally 
        {
            DBManager.close(ps, conn);
        }

        return (cnt == 1);
    }

    // 특정댓글 조회
    public FreeCom getCommentById(long freeComSeq) 
    {
        FreeCom comment = null;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        StringBuilder sb = new StringBuilder();

        sb.append("SELECT FREE_COM_SEQ, FREE_BBS_SEQ, USER_ID, FREE_COM_CONTENT, FREE_COM_STATUS, REG_DATE ")
          .append("FROM FREE_COM WHERE FREE_COM_SEQ = ? ");

        try 
        {
            conn = DBManager.getConnection();
            ps = conn.prepareStatement(sb.toString());
            ps.setLong(1, freeComSeq);
            rs = ps.executeQuery();

            if (rs.next()) 
            {
                comment = new FreeCom();
                comment.setFreeComSeq(rs.getLong("FREE_COM_SEQ"));
                comment.setFreeBbsSeq(rs.getLong("FREE_BBS_SEQ"));
                comment.setUserId(rs.getString("USER_ID"));
                comment.setFreeComContent(rs.getString("FREE_COM_CONTENT"));
                comment.setFreeComStatus(rs.getString("FREE_COM_STATUS"));
                comment.setRegDate(rs.getString("REG_DATE"));
            }
        } 
        catch (SQLException e) 
        {
            logger.error("[FreeComDao]getCommentById SQLException", e);
        }
        finally 
        {
            DBManager.close(rs, ps, conn);
        }

        return comment;
    }
}