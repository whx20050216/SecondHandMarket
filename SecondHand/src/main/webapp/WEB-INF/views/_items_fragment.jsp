<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="items-grid">
    <c:forEach items="${items}" var="item">
        <div class="item-card">
            <h5 class="item-title">${item.title}</h5>
            <p class="item-price">¥${item.price}</p>
            <p>
                <span class="status-badge ${item.status == 'on_sale' ? 'status-on-sale' : 'status-sold'}">
                        ${item.status == 'on_sale' ? '在售' : '已售出'}
                </span>
            </p>
            <a href="${pageContext.request.contextPath}/item/detail?id=${item.id}" class="btn btn-primary btn-sm">查看详情</a>
        </div>
    </c:forEach>
</div>