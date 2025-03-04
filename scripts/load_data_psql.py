import pandas as pd
import os
from sqlalchemy import create_engine, text

# Database connection parameters
DB_USER = "postgres"
DB_PASSWORD = "bubuleh"
DB_HOST = "172.17.0.3"
DB_PORT = "5432"
DB_NAME = "assigment2"

engine = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')

# Show all tables
with engine.connect() as connection:
    result = connection.execute(text("SELECT table_name FROM information_schema.tables WHERE table_schema='public'"))
    print(result.fetchall())

PREFIX = "../data_clean"
csv_files = {
    'client_first_purchase': 'client_first_purchase_date.csv',
    'campaigns': 'campaigns.csv',
    'events': 'events.csv',
    'messages': 'messages.csv',
    'friends': 'friends.csv'
}
for table, file in csv_files.items():
    csv_files[table] = os.path.join(PREFIX, file)

# 1. load tables without foreign key dependencies
print("Loading client_first_purchase data...")
df_client = pd.read_csv(csv_files['client_first_purchase'])
df_client.to_sql('client_first_purchase', engine, if_exists='append', index=False)

print("Loading campaigns data...")
df_campaigns = pd.read_csv(csv_files['campaigns'])
df_campaigns.to_sql('campaigns', engine, if_exists='append', index=False)

print("Loading friends data...")
df_friends = pd.read_csv(csv_files['friends'])
df_friends.to_sql('friends', engine, if_exists='append', index=False)

# 2. load tables with foreign key dependencies
print("Loading events data...")
df_events = pd.read_csv(csv_files['events'])
df_events.to_sql('events', engine, if_exists='append', index=False)

print("Loading messages data...")
df_messages = pd.read_csv(csv_files['messages'], low_memory=False)
df_messages.to_sql('messages', engine, if_exists='append', index=False)

print("Data loading complete!")