package com.secondhand.dao.Impl;

import com.secondhand.dao.UserDao;
import com.secondhand.entity.User;
import com.secondhand.util.DBUtil;

public class UserDaoImpl implements UserDao {

    //定义映射规则
    private static final DBUtil.RowMapper<User> USER_MAPPER = rs -> {
        User user = new User();
        user.setId(rs.getLong("id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setCreateTime(rs.getTimestamp("create_time").toLocalDateTime());
        return user;
    };

    @Override
    public int insert(User user) {
        String sql = "INSERT INTO user(username, password, email, phone) VALUES(?, ?, ?, ?)";
        return DBUtil.executeUpdate(sql,
                user.getUsername(),
                user.getPassword(),
                user.getEmail(),
                user.getPhone()
        );
    }

    //查询方法直接调用
    @Override
    public User findByUsername(String username) {
        String sql = "SELECT * FROM user WHERE username = ?";
        return DBUtil.executeQuery(sql, USER_MAPPER, username)
                .stream()
                .findFirst()
                .orElse(null); // 取第一条，无则返回null
    }

    @Override
    public User findById(Long id) {
        String sql = "SELECT * FROM user WHERE id = ?";
        return DBUtil.executeQuery(sql, USER_MAPPER, id)
                .stream()
                .findFirst()
                .orElse(null);
    }
}