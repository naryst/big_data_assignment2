import pandas as pd
import os

PREFIX = "../data_clean"


client_first_purchase_date = pd.read_csv(os.path.join(PREFIX, "client_first_purchase_date.csv"))


date_fields = [
    'started_at',
    'finished_at',
]
campaigns = pd.read_csv(os.path.join(PREFIX, "campaigns.csv"))

date_fields = [
    'event_time',
]
events = pd.read_csv(os.path.join(PREFIX, "events.csv"))

date_fields = [
    'date',
    'sent_at',
]
messages = pd.read_csv(os.path.join(PREFIX, "messages.csv"))
friends = pd.read_csv(os.path.join(PREFIX, "friends.csv"))

