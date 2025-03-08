SELECT 
    c.id AS campaign_id,
    c.campaign_type,
    c.channel,
    c.topic,
    COUNT(m.message_id) AS total_messages,
    SUM(CASE WHEN m.is_purchased = TRUE THEN 1 ELSE 0 END) AS purchases,
    ROUND((SUM(CASE WHEN m.is_purchased = TRUE THEN 1 ELSE 0 END)::DECIMAL / 
           COUNT(m.message_id)) * 100, 2) AS conversion_rate,
    AVG(EXTRACT(EPOCH FROM (m.purchased_at - m.sent_at))/3600)::DECIMAL(10,2) AS avg_hours_to_purchase
FROM 
    campaigns c
JOIN 
    messages m ON c.id = m.campaign_id
GROUP BY 
    c.id, c.campaign_type, c.channel, c.topic
HAVING 
    ROUND((SUM(CASE WHEN m.is_purchased = TRUE THEN 1 ELSE 0 END)::DECIMAL / 
           COUNT(m.message_id)) * 100, 2) > 0
ORDER BY 
    conversion_rate DESC;

