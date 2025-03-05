MATCH (n) DETACH DELETE n;

// Unique ID constraints
CREATE CONSTRAINT client_id IF NOT EXISTS FOR (c:Client) REQUIRE c.client_id IS UNIQUE;
CREATE CONSTRAINT user_id IF NOT EXISTS FOR (c:Client) REQUIRE c.user_id IS UNIQUE;
CREATE CONSTRAINT campaign_id IF NOT EXISTS FOR (camp:Campaign) REQUIRE camp.id IS UNIQUE;
CREATE CONSTRAINT message_id IF NOT EXISTS FOR (m:Message) REQUIRE m.message_id IS UNIQUE;
CREATE CONSTRAINT product_id IF NOT EXISTS FOR (p:Product) REQUIRE p.product_id IS UNIQUE;

// Search indexes
CREATE INDEX event_type IF NOT EXISTS FOR (e:Event) ON (e.event_type);
CREATE INDEX campaign_type IF NOT EXISTS FOR (c:Campaign) ON (c.campaign_type);

// Load Client data
LOAD CSV WITH HEADERS FROM 'file:///client_first_purchase_date.csv' AS row
CREATE (c:Client {
    client_id: row.client_id,
    user_id: toInteger(row.user_id),
    user_device_id: toInteger(row.user_device_id),
    first_purchase_date: date(row.first_purchase_date)
});

// Load Campaign data
LOAD CSV WITH HEADERS FROM 'file:///campaigns.csv' AS row
CREATE (c:Campaign {
    id: toInteger(row.id),
    campaign_type: row.campaign_type,
    channel: row.channel,
    topic: row.topic,
    started_at: datetime(row.started_at),
    finished_at: datetime(row.finished_at),
    total_count: toInteger(row.total_count),
    ab_test: toBoolean(row.ab_test),
    warmup_mode: toBoolean(row.warmup_mode),
    hour_limit: toFloat(row.hour_limit),
    subject_length: toFloat(row.subject_length),
    subject_with_personalization: toBoolean(CASE WHEN row.subject_with_personalization = 't' THEN true ELSE false END),
    subject_with_deadline: toBoolean(CASE WHEN row.subject_with_deadline = 't' THEN true ELSE false END),
    subject_with_emoji: toBoolean(CASE WHEN row.subject_with_emoji = 't' THEN true ELSE false END),
    subject_with_bonuses: toBoolean(CASE WHEN row.subject_with_bonuses = 't' THEN true ELSE false END),
    subject_with_discount: toBoolean(CASE WHEN row.subject_with_discount = 't' THEN true ELSE false END),
    subject_with_saleout: toBoolean(CASE WHEN row.subject_with_saleout = 't' THEN true ELSE false END),
    is_test: toBoolean(CASE WHEN row.is_test = 't' THEN true ELSE false END),
    position: toInteger(row.position)
});

// Load Product data (extracted from events)
LOAD CSV WITH HEADERS FROM 'file:///events.csv' AS row
MERGE (p:Product {
    product_id: toInteger(row.product_id)
})
ON CREATE SET 
    p.category_id = CASE WHEN row.category_id <> '' THEN toInteger(row.category_id) ELSE null END,
    p.category_code = row.category_code,
    p.brand = row.brand,
    p.price = CASE WHEN row.price <> '' THEN toFloat(row.price) ELSE null END;

// Load Event data and create relationships
LOAD CSV WITH HEADERS FROM 'file:///events.csv' AS row
MATCH (c:Client {user_id: toInteger(row.user_id)})
MATCH (p:Product {product_id: toInteger(row.product_id)})
CREATE (e:Event {
    event_id: toInteger(row.event_id),
    event_time: datetime(row.event_time),
    event_type: row.event_type,
    user_session: row.user_session
})
CREATE (c)-[:GENERATED]->(e)
CREATE (e)-[:INVOLVES]->(p);

// Load Message data and create relationships
LOAD CSV WITH HEADERS FROM 'file:///messages.csv' AS row
MATCH (client:Client {client_id: row.client_id})
MATCH (campaign:Campaign {id: toInteger(row.campaign_id)})
CREATE (m:Message {
    message_id: row.message_id,
    id: CASE WHEN row.id <> '' THEN toInteger(row.id) ELSE null END,
    message_type: row.message_type,
    channel: row.channel,
    email_provider: row.email_provider,
    platform: row.platform,
    stream: row.stream,
    category: row.category,
    date: date(row.date),
    sent_at: datetime(row.sent_at),
    is_opened: toBoolean(row.is_opened),
    opened_first_time_at: CASE WHEN row.opened_first_time_at <> '' THEN datetime(row.opened_first_time_at) ELSE null END,
    opened_last_time_at: CASE WHEN row.opened_last_time_at <> '' THEN datetime(row.opened_last_time_at) ELSE null END,
    is_clicked: toBoolean(row.is_clicked),
    clicked_first_time_at: CASE WHEN row.clicked_first_time_at <> '' THEN datetime(row.clicked_first_time_at) ELSE null END,
    clicked_last_time_at: CASE WHEN row.clicked_last_time_at <> '' THEN datetime(row.clicked_last_time_at) ELSE null END,
    is_unsubscribed: toBoolean(CASE WHEN row.is_unsubscribed = 't' THEN true ELSE false END),
    unsubscribed_at: CASE WHEN row.unsubscribed_at <> '' THEN datetime(row.unsubscribed_at) ELSE null END,
    is_hard_bounced: toBoolean(CASE WHEN row.is_hard_bounced = 't' THEN true ELSE false END),
    hard_bounced_at: CASE WHEN row.hard_bounced_at <> '' THEN datetime(row.hard_bounced_at) ELSE null END,
    is_soft_bounced: toBoolean(CASE WHEN row.is_soft_bounced = 't' THEN true ELSE false END),
    soft_bounced_at: CASE WHEN row.soft_bounced_at <> '' THEN datetime(row.soft_bounced_at) ELSE null END,
    is_complained: toBoolean(CASE WHEN row.is_complained = 't' THEN true ELSE false END),
    complained_at: CASE WHEN row.complained_at <> '' THEN datetime(row.complained_at) ELSE null END,
    is_blocked: toBoolean(CASE WHEN row.is_blocked = 't' THEN true ELSE false END),
    blocked_at: CASE WHEN row.blocked_at <> '' THEN datetime(row.blocked_at) ELSE null END,
    is_purchased: toBoolean(CASE WHEN row.is_purchased = 't' THEN true ELSE false END),
    purchased_at: CASE WHEN row.purchased_at <> '' THEN datetime(row.purchased_at) ELSE null END,
    created_at: datetime(row.created_at),
    updated_at: datetime(row.updated_at),
    user_device_id: toInteger(row.user_device_id),
    user_id: toInteger(row.user_id)
})
CREATE (client)-[:RECEIVED]->(m)
CREATE (campaign)-[:INCLUDES]->(m);

// Load Friends data
LOAD CSV WITH HEADERS FROM 'file:///friends.csv' AS row
MATCH (c1:Client {user_id: toInteger(row.friend1)})
MATCH (c2:Client {user_id: toInteger(row.friend2)})
CREATE (c1)-[:FRIENDS_WITH]->(c2);

// Create indexes for better query performance
CREATE INDEX event_time IF NOT EXISTS FOR (e:Event) ON (e.event_time);
CREATE INDEX message_sent IF NOT EXISTS FOR (m:Message) ON (m.sent_at);
CREATE INDEX message_purchased IF NOT EXISTS FOR (m:Message) ON (m.is_purchased);
