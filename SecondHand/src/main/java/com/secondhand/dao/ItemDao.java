package com.secondhand.dao;

import com.secondhand.entity.Item;
import java.util.List;

public interface ItemDao {
    int insert(Item item);
    int update(Item item);
    int delete(Long id, Long userId);
    int markAsSold(Long id, Long userId);
    Item findById(Long id);
    List<Item> findByFuzzyKeyword(String keyword);
    List<Item> findAll();
    List<Item> findByUserId(Long userId);
}