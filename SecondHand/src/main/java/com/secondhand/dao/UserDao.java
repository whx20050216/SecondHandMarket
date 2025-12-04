package com.secondhand.dao;

import com.secondhand.entity.User;
import java.util.List;

public interface UserDao {
    int insert(User user);
    User findByUsername(String username);
    User findById(Long id);
}