package com.secondhand.service;

import com.secondhand.entity.Item;
import java.util.List;

public interface ItemService {
    boolean publish(Item item); // 发布物品
    boolean update(Item item, Long currentUserId); // 修改物品
    boolean delete(Long itemId, Long currentUserId); // 删除物品
    boolean markAsSold(Long itemId, Long userId); // 标记售出

    Item getById(Long id); // 查询单个
    List<Item> getAllItems(); // 查询所有
    List<Item> getUserItems(Long userId); // 查询用户物品
    List<Item> searchItems(String keyword); // 模糊搜索
    boolean purchase(Long itemId, Long buyerId); // 购买物品
}