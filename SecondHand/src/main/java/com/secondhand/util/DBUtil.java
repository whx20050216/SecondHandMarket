package com.secondhand.util;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DBUtil {
    private static final String URL = "jdbc:mysql://10.100.164.17:3306/SecondHand?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
    private static final String USER = "second";
    private static final String PASSWORD = "@sh67813964";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("数据库驱动加载失败", e);
        }
    }

    // 获取连接
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // 自动绑定参数并执行更新
    public static int executeUpdate(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("SQL执行失败: " + sql, e);
        } finally {
            close(conn, pstmt, null);
        }
    }

    // 自动绑定参数并执行查询
    public static <T> List<T> executeQuery(String sql, RowMapper<T> mapper, Object... params) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<T> result = new ArrayList<>();
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            rs = pstmt.executeQuery();
            while (rs.next()) {
                result.add(mapper.mapRow(rs)); // 自动映射每一行
            }
            return result;
        } catch (SQLException e) {
            throw new RuntimeException("查询失败: " + sql, e);
        } finally {
            close(conn, pstmt, rs);
        }
    }

    // 函数式接口：定义如何将ResultSet映射成对象
    @FunctionalInterface
    public interface RowMapper<T> {
        T mapRow(ResultSet rs) throws SQLException;
    }

    // 关闭资源
    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
}