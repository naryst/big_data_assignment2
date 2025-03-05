-- Drop all tables if they exist (in correct order to avoid constraint violations)
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS campaigns;
DROP TABLE IF EXISTS friends;
DROP TABLE IF EXISTS client_first_purchase;

-- Create table for client first purchase date
CREATE TABLE client_first_purchase (
    client_id VARCHAR(100) PRIMARY KEY,
    first_purchase_date DATE NOT NULL,
    user_id BIGINT NOT NULL,
    user_device_id BIGINT NOT NULL,
    UNIQUE (user_id)
);

-- Create table for campaigns
CREATE TABLE campaigns (
    id BIGINT PRIMARY KEY,
    campaign_type VARCHAR(20) NOT NULL,
    channel VARCHAR(20) NOT NULL,
    topic VARCHAR(100),
    started_at TIMESTAMP,
    finished_at TIMESTAMP,
    total_count INTEGER,
    ab_test BOOLEAN,
    warmup_mode BOOLEAN,
    hour_limit DECIMAL(10, 2),
    subject_length DECIMAL(10, 2),
    subject_with_personalization BOOLEAN,
    subject_with_deadline BOOLEAN,
    subject_with_emoji BOOLEAN,
    subject_with_bonuses BOOLEAN,
    subject_with_discount BOOLEAN,
    subject_with_saleout BOOLEAN,
    is_test BOOLEAN,
    position INTEGER
);

CREATE INDEX idx_campaigns_type ON campaigns(campaign_type);
CREATE INDEX idx_campaigns_channel ON campaigns(channel);

-- Create table for events data
CREATE TABLE events (
    event_id SERIAL PRIMARY KEY,
    event_time TIMESTAMP NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    product_id BIGINT NOT NULL,
    category_id BIGINT,
    category_code VARCHAR(100),
    brand VARCHAR(100),
    price DECIMAL(10, 2),
    user_id BIGINT NOT NULL,
    user_session VARCHAR(100)
);

CREATE INDEX idx_events_user_id ON events(user_id);
CREATE INDEX idx_events_product_id ON events(product_id);
CREATE INDEX idx_events_event_type ON events(event_type);
CREATE INDEX idx_events_event_time ON events(event_time);

-- Create table for messages
CREATE TABLE messages (
    id BIGINT,
    message_id VARCHAR(100) PRIMARY KEY,
    campaign_id BIGINT NOT NULL,
    message_type VARCHAR(20) NOT NULL,
    channel VARCHAR(20) NOT NULL,
    client_id VARCHAR(100) NOT NULL,
    email_provider VARCHAR(100),
    platform VARCHAR(50),
    stream VARCHAR(50),
    category VARCHAR(100),
    date DATE NOT NULL,
    sent_at TIMESTAMP NOT NULL,
    is_opened BOOLEAN,
    opened_first_time_at TIMESTAMP,
    opened_last_time_at TIMESTAMP,
    is_clicked BOOLEAN,
    clicked_first_time_at TIMESTAMP,
    clicked_last_time_at TIMESTAMP,
    is_unsubscribed BOOLEAN,
    unsubscribed_at TIMESTAMP,
    is_hard_bounced BOOLEAN,
    hard_bounced_at TIMESTAMP,
    is_soft_bounced BOOLEAN,
    soft_bounced_at TIMESTAMP,
    is_complained BOOLEAN,
    complained_at TIMESTAMP,
    is_blocked BOOLEAN,
    blocked_at TIMESTAMP,
    is_purchased BOOLEAN,
    purchased_at TIMESTAMP,
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    user_device_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (campaign_id) REFERENCES campaigns(id)
);

-- Create indexes for messages table
CREATE INDEX idx_messages_campaign_id ON messages(campaign_id);
CREATE INDEX idx_messages_client_id ON messages(client_id);
CREATE INDEX idx_messages_date ON messages(date);
CREATE INDEX idx_messages_is_purchased ON messages(is_purchased);

-- Create table for friends
CREATE TABLE friends (
    friend1 BIGINT NOT NULL,
    friend2 BIGINT NOT NULL,
    PRIMARY KEY (friend1, friend2)
);

-- Create indexes for friends table
CREATE INDEX idx_friends_friend1 ON friends(friend1);
CREATE INDEX idx_friends_friend2 ON friends(friend2);