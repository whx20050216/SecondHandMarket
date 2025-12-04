package com.secondhand.service.Impl;

import com.secondhand.dao.ItemDao;
import com.secondhand.dao.impl.ItemDaoImpl;
import com.secondhand.entity.Item;
import com.secondhand.service.ItemService;
import java.util.List;

public class ItemServiceImpl implements ItemService {

    private ItemDao itemDao = new ItemDaoImpl();

    @Override
    public boolean publish(Item item) {
        // 发布时默认状态就是on_sale，Dao里已处理
        return itemDao.insert(item) > 0;
    }

    @Override
    public boolean update(Item item, Long currentUserId) {
        // ================= 核心要求：只能修改自己的物品 =================
        Item oldItem = itemDao.findById(item.getId());
        if (oldItem == null || !oldItem.getUserId().equals(currentUserId)) {
            return false; // 无权修改
        }
        return itemDao.update(item) > 0;
    }

    @Override
    public boolean delete(Long itemId, Long currentUserId) {
        // ================= 核心要求：只能删除自己的物品 =================
        Item item = itemDao.findById(itemId);
        if (item == null || !item.getUserId().equals(currentUserId)) {
            return false; // 无权删除
        }
        return itemDao.delete(itemId, currentUserId) > 0;
    }

    @Override
    public Item getById(Long id) {
        return itemDao.findById(id);
    }

    @Override
    public List<Item> getAllItems() {
        return itemDao.findAll();
    }

    @Override
    public List<Item> getUserItems(Long userId) {
        return itemDao.findByUserId(userId);
    }

    // ================= 作业要求：模糊查询 =================
    @Override
    public List<Item> searchItems(String keyword) {
        // 1. 处理参数：前后加 % 实现模糊匹配
        String fuzzyKeyword = "%" + keyword + "%";

        // 2. 调用Dao的模糊查询
        return itemDao.findByFuzzyKeyword(fuzzyKeyword);
    }

    // ================= 标记售出 =================
    @Override
    public boolean markAsSold(Long itemId, Long userId) {
        Item item = itemDao.findById(itemId);
        if (item == null || !item.getUserId().equals(userId)) {
            return false; // 只能标记自己的
        }
        return itemDao.markAsSold(itemId, userId) > 0;
    }
}