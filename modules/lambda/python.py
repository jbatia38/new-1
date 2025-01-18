import boto3
import os
from datetime import datetime, timedelta

def lambda_handler(event, context):
    iam_client = boto3.client('iam')
    inactive_days_threshold = int(os.environ.get("INACTIVE_DAYS_THRESHOLD", 2))
    cutoff_date = datetime.now() - timedelta(days=inactive_days_threshold)

    response = iam_client.list_users()

    for user in response['Users']:
        username = user['UserName']
        last_used = user.get('PasswordLastUsed', None)

        if last_used and last_used < cutoff_date:
            print(f"Disabling user: {username} (last used on {last_used})")
            iam_client.update_user(UserName=username, NewPath="/inactive/")
        else:
            print(f"User {username} is active or does not have a password.")
