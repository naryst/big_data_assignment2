use("assignment2");

["client_first_purchase_date", "campaigns", "events", "messages", "friends"].forEach(collection => {
    db[collection].drop();
});

db.createCollection("client_first_purchase_date", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "user_id", "user_device_id", "first_purchase_date"],
      properties: {
        _id: { bsonType: "string" },
        client_id: { bsonType: "string" },
        user_id: { bsonType: "long" },
        user_device_id: { bsonType: "long" },
        first_purchase_date: { bsonType: "date" }
      }
    }
  }
});

db.createCollection("campaigns", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "campaign_type", "channel"],
      properties: {
        _id: { bsonType: "long" },
        campaign_type: { bsonType: "string" },
        channel: { bsonType: "string" },
        topic: { bsonType: "string" },
        started_at: { bsonType: "date" },
        finished_at: { bsonType: "date" },
        total_count: { bsonType: "int" },
        ab_test: { bsonType: "bool" },
        warmup_mode: { bsonType: "bool" },
        hour_limit: { bsonType: "double" },
        subject: {
          bsonType: "object",
          properties: {
            length: { bsonType: "double" },
            with_personalization: { bsonType: "bool" },
            with_deadline: { bsonType: "bool" },
            with_emoji: { bsonType: "bool" },
            with_bonuses: { bsonType: "bool" },
            with_discount: { bsonType: "bool" },
            with_saleout: { bsonType: "bool" }
          }
        },
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
      required: ["event_time", "event_type", "product", "user_id"],
      properties: {
        _id: { bsonType: "objectId" },
        event_time: { bsonType: "date" },
        event_type: { bsonType: "string" },
        product: {
          bsonType: "object",
          required: ["id"],
          properties: {
            id: { bsonType: "long" },
            price: { bsonType: "double" },
            category_id: { bsonType: "long" },
            category_code: { bsonType: "string" },
            brand: { bsonType: "string" }
          }
        },
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
      required: ["_id", "campaign_id", "message_type", "channel", "client_id", "date", "sent_at", "timestamps"],
      properties: {
        _id: { bsonType: "string" },
        numeric_id: { bsonType: "long" },
        campaign_id: { bsonType: "long" },
        message_type: { bsonType: "string" },
        channel: { bsonType: "string" },
        client_id: { bsonType: "string" },
        user: {
          bsonType: "object",
          required: ["user_id", "user_device_id"],
          properties: {
            user_id: { bsonType: "long" },
            user_device_id: { bsonType: "long" }
          }
        },
        delivery: {
          bsonType: "object",
          properties: {
            email_provider: { bsonType: "string" },
            platform: { bsonType: "string" },
            stream: { bsonType: "string" },
            category: { bsonType: "string" }
          }
        },
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
        timestamps: {
          bsonType: "object",
          required: ["created_at", "updated_at"],
          properties: {
            created_at: { bsonType: "date" },
            updated_at: { bsonType: "date" }
          }
        }
      }
    }
  }
});

db.createCollection("friends", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["users"],
      properties: {
        _id: { bsonType: "objectId" },
        users: {
          bsonType: "array",
          minItems: 2,
          maxItems: 2,
          items: { bsonType: "long" }
        }
      }
    }
  }
});

print("Database initialized.");