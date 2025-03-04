import os
import pandas as pd

RAW_DATA_DIR = "../data_raw"
CLEAN_DATA_DIR = "../data_clean"

os.makedirs(CLEAN_DATA_DIR, exist_ok=True)


def clean_client_first_purchase(df):
    # Convert date to proper format
    df["first_purchase_date"] = pd.to_datetime(df["first_purchase_date"]).dt.date

    # sort by purchase date
    df = df.sort_values("first_purchase_date")

    df["first_purchase_date"] = df["first_purchase_date"].apply(
        lambda x: x.strftime("%Y-%m-%d") if pd.notna(x) else None
    )

    # Drop duplicates leaving the first purchase
    df = df.drop_duplicates(subset=["client_id"], keep="first")
    df = df.drop_duplicates(subset=["user_id"], keep="first")

    return df


def clean_campaigns(df):
    # Convert timestamps
    if "started_at" in df.columns:
        df["started_at"] = pd.to_datetime(df["started_at"]).apply(
            lambda x: x.strftime("%Y-%m-%d %H:%M:%S.%f").replace(" ", "T")
            if pd.notna(x)
            else None
        )
    if "finished_at" in df.columns:
        df["finished_at"] = pd.to_datetime(df["finished_at"]).apply(
            lambda x: x.strftime("%Y-%m-%d %H:%M:%S.%f").replace(" ", "T")
            if pd.notna(x)
            else None
        )

    # Drop duplicates
    df = df.drop_duplicates(subset=["id"])
    return df


def clean_events(df, client_df):
    # Convert timestamp
    df["event_time"] = pd.to_datetime(df["event_time"]).apply(
        lambda x: x.strftime("%Y-%m-%d %H:%M:%S.%f").replace(" ", "T")
        if pd.notna(x)
        else None
    )
    return df


def clean_messages(df):
    timestamp_cols = [
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

    for col in timestamp_cols:
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce").apply(
                lambda x: x.strftime("%Y-%m-%d %H:%M:%S.%f").replace(" ", "T")
                if pd.notna(x)
                else None
            )
    return df


def clean_friends(df):
    # Drop duplicates
    df = df.drop_duplicates()

    return df


def main():
    # Process client_first_purchase data
    client_files = os.path.join(RAW_DATA_DIR, "client_first_purchase_date.csv")
    client_df = pd.read_csv(client_files)
    client_df = clean_client_first_purchase(client_df)
    client_df.to_csv(
        os.path.join(CLEAN_DATA_DIR, "client_first_purchase_date.csv"), index=False
    )
    print(f"Processed client_first_purchase: {len(client_df)} records")

    # Process campaigns data
    campaign_files = os.path.join(RAW_DATA_DIR, "campaigns.csv")
    campaign_df = pd.read_csv(campaign_files)
    campaign_df = clean_campaigns(campaign_df)
    campaign_df.to_csv(os.path.join(CLEAN_DATA_DIR, "campaigns.csv"), index=False)
    print(f"Processed campaigns: {len(campaign_df)} records")

    # Process events data
    events_files = os.path.join(RAW_DATA_DIR, "events.csv")
    events_df = pd.read_csv(events_files)
    events_df = clean_events(events_df, client_df)
    events_df.to_csv(os.path.join(CLEAN_DATA_DIR, "events.csv"), index=False)
    print(f"Processed events: {len(events_df)} records")

    # Process messages data
    messages_files = os.path.join(RAW_DATA_DIR, "messages.csv")
    messages_df = pd.read_csv(messages_files, low_memory=False)
    messages_df = clean_messages(messages_df)
    messages_df.to_csv(os.path.join(CLEAN_DATA_DIR, "messages.csv"), index=False)
    print(f"Processed messages: {len(messages_df)} records")

    # Process friends data
    friends_files = os.path.join(RAW_DATA_DIR, "friends.csv")
    friends_df = pd.read_csv(friends_files)
    friends_df = clean_friends(friends_df)
    friends_df.to_csv(os.path.join(CLEAN_DATA_DIR, "friends.csv"), index=False)
    print(f"Processed friends: {len(friends_df)} records")


if __name__ == "__main__":
    main()
