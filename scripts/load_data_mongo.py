import pandas as pd
import os
from pymongo import MongoClient

# MongoDB connection parameters
MONGO_HOST = "localhost"
MONGO_PORT = 27017
MONGO_DB = "assignment2"


def convert_to_datetime(df, column_name):
    if column_name in df.columns:
        df[column_name] = pd.to_datetime(df[column_name], errors="coerce", utc=True)
        df[column_name] = (
            df[column_name].astype(object).where(df[column_name].notnull(), None)
        )
    return df


# Connect to MongoDB
client = MongoClient(MONGO_HOST, MONGO_PORT)
db = client[MONGO_DB]

print("Existing collections:", db.list_collection_names())

PREFIX = "../data_clean"
csv_files = {
    "client_first_purchase": "client_first_purchase_date.csv",
    "campaigns": "campaigns.csv",
    "events": "events.csv",
    "messages": "messages.csv",
    "friends": "friends.csv",
}
for collection, file in csv_files.items():
    csv_files[collection] = os.path.join(PREFIX, file)

print("Loading client_first_purchase data...")
df_client = pd.read_csv(csv_files["client_first_purchase"])
df_client = convert_to_datetime(df_client, "first_purchase_date")
db.client_first_purchase.drop()  # Drop collection if exists
db.client_first_purchase.insert_many(df_client.to_dict("records"))

print("Loading campaigns data...")
df_campaigns = pd.read_csv(csv_files["campaigns"])
df_campaigns = convert_to_datetime(df_campaigns, "started_at")
df_campaigns = convert_to_datetime(df_campaigns, "finished_at")
db.campaigns.drop()
db.campaigns.insert_many(df_campaigns.to_dict("records"))

print("Loading friends data...")
df_friends = pd.read_csv(csv_files["friends"])
db.friends.drop()
db.friends.insert_many(df_friends.to_dict("records"))

print("Loading events data...")
df_events = pd.read_csv(csv_files["events"])
df_events = convert_to_datetime(df_events, "event_time")
db.events.drop()
db.events.insert_many(df_events.to_dict("records"))

print("Loading messages data...")
df_messages = pd.read_csv(csv_files["messages"], low_memory=False)
# Convert all date columns in messages
date_columns = [
    "date",
    "sent_at",
    "opened_first_time_at",
    "opened_last_time_at",
    "clicked_first_time_at",
    "clicked_last_time_at",
    "unsubscribed_at",
    "hard_bounced_at",
    "soft_bounced_at",
    "complained_at",
    "blocked_at",
    "purchased_at",
    "created_at",
    "updated_at",
]
for date_col in date_columns:
    df_messages = convert_to_datetime(df_messages, date_col)


db.messages.drop()
db.messages.insert_many(df_messages.to_dict("records"))

print("Data loading complete!")

for collection in csv_files.keys():
    count = db[collection].count_documents({})
    print(f"{collection}: {count} documents")
