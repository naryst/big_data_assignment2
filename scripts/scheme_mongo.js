use("assignment2");

["client_first_purchase", "campaigns", "events", "messages", "friends"].forEach(collection => {
    db[collection].drop();
});

db.createCollection("client_first_purchase", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["client_id", "first_purchase_date", "user_id", "user_device_id"],
      properties: {
        client_id: { bsonType: "string" },
        first_purchase_date: { bsonType: "date" },
        user_id: { bsonType: "long" },
        user_device_id: { bsonType: "long" }
      }
    }
  }
});

db.createCollection("campaigns", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["id", "campaign_type", "channel"],
      properties: {
        id: { bsonType: "long" },
        campaign_type: { bsonType: "string" },
        channel: { bsonType: "string" },
        topic: { bsonType: "string" },
        started_at: { bsonType: "date" },
        finished_at: { bsonType: "date" },
        total_count: { bsonType: "int" },
        ab_test: { bsonType: "bool" },
        warmup_mode: { bsonType: "bool" },
        hour_limit: { bsonType: "double" },
        subject_length: { bsonType: "double" },
        subject_with_personalization: { bsonType: "bool" },
        subject_with_deadline: { bsonType: "bool" },
        subject_with_emoji: { bsonType: "bool" },
        subject_with_bonuses: { bsonType: "bool" },
        subject_with_discount: { bsonType: "bool" },
        subject_with_saleout: { bsonType: "bool" },
        is_test: { bsonType: "bool" },
        position: { bsonType: "int" }
      }
    }
  }
});

db.createCollection("events", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["event_time", "event_type", "product_id", "user_id"],
      properties: {
        event_id: { bsonType: "int" },
        event_time: { bsonType: "date" },
        event_type: { bsonType: "string" },
        product_id: { bsonType: "long" },
        category_id: { bsonType: "long" },
        category_code: { bsonType: "string" },
        brand: { bsonType: "string" },
        price: { bsonType: "double" },
        user_id: { bsonType: "long" },
        user_session: { bsonType: "string" }
      }
    }
  }
});

db.createCollection("messages", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["message_id", "campaign_id", "message_type", "channel", "client_id", "date", "sent_at", "user_device_id", "user_id"],
      properties: {
        id: { bsonType: "long" },
        message_id: { bsonType: "string" },
        campaign_id: { bsonType: "long" },
        message_type: { bsonType: "string" },
        channel: { bsonType: "string" },
        client_id: { bsonType: "string" },
        email_provider: { bsonType: "string" },
        platform: { bsonType: "string" },
        stream: { bsonType: "string" },
        category: { bsonType: "string" },
        date: { bsonType: "date" },
        sent_at: { bsonType: "date" },
        is_opened: { bsonType: "bool" },
        opened_first_time_at: { bsonType: "date" },
        opened_last_time_at: { bsonType: "date" },
        is_clicked: { bsonType: "bool" },
        clicked_first_time_at: { bsonType: "date" },
        clicked_last_time_at: { bsonType: "date" },
        is_unsubscribed: { bsonType: "bool" },
        unsubscribed_at: { bsonType: "date" },
        is_hard_bounced: { bsonType: "bool" },
        hard_bounced_at: { bsonType: "date" },
        is_soft_bounced: { bsonType: "bool" },
        soft_bounced_at: { bsonType: "date" },
        is_complained: { bsonType: "bool" },
        complained_at: { bsonType: "date" },
        is_blocked: { bsonType: "bool" },
        blocked_at: { bsonType: "date" },
        is_purchased: { bsonType: "bool" },
        purchased_at: { bsonType: "date" },
        created_at: { bsonType: "date" },
        updated_at: { bsonType: "date" },
        user_device_id: { bsonType: "long" },
        user_id: { bsonType: "long" }
      }
    }
  }
});

db.createCollection("friends", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["friend1", "friend2"],
      properties: {
        friend1: { bsonType: "long" },
        friend2: { bsonType: "long" }
      }
    }
  }
});

print("Database initialized.");