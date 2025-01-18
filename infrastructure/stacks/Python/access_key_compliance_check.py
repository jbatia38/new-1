import boto3
import datetime

role_name = "AccessKeyComplianceCheck"
sender_email = "obello5050@gmail.com"
sts = boto3.client('sts')
orgs = boto3.client('organizations')
ses = boto3.client('ses', region_name='us-east-1')

def lambda_handler(event, context):
  assumed_count, email_sent_count, accounts = 0, 0, []
  response = orgs.list_accounts()
  accounts.extend(response['Accounts'])
  while 'NextToken' in response:
    response = orgs.list_accounts(NextToken=response['NextToken'])
    accounts.extend(response['Accounts'])
    
  total_accounts = len(accounts)
  for account in accounts:
    creds = assume_role(account['Id'])
    if not creds:
      continue
    assumed_count += 1
    iam = boto3.client('iam', aws_access_key_id=creds['AccessKeyId'],
              aws_secret_access_key=creds['SecretAccessKey'],
              aws_session_token=creds['SessionToken'], region_name='us-east-1')
    for user in iam.list_users()['Users']:
      print(f"Performing actions in account {account['Id']} for user {user['UserName']}")
      keys_to_notify = [key['AccessKeyId'] for key in iam.list_access_keys(UserName=user['UserName'])['AccessKeyMetadata']
               if key['Status'] == 'Active' and (datetime.datetime.now(datetime.timezone.utc) - key['CreateDate']).days > 2]
      if keys_to_notify:
        email = get_email(iam.list_user_tags(UserName=user['UserName'])['Tags'])
        if email and send_email(email, user['UserName'], keys_to_notify):
          email_sent_count += 1
          print(f"Email successfully sent to {email} for user {user['UserName']}.")
  print(f"Total accounts in the organization: {total_accounts}")
  print(f"Number of accounts successfully assumed: {assumed_count}")
  print(f"Number of emails successfully sent: {email_sent_count}")
def assume_role(account_id):
  try:
    print(f"Assuming role in account {account_id}")
    response = sts.assume_role(
      RoleArn=f'arn:aws:iam::{account_id}:role/{role_name}',
      RoleSessionName='KeyRotationCheckSession'
    )
    print(f"Successfully assumed role in account {account_id}")
    return response['Credentials']
  except sts.exceptions.ClientError as e:
    print(f"{'Access Denied' if 'AccessDenied' in str(e) else 'Error'} when assuming role for account {account_id}: {e}")
    return None
def get_email(tags):
  for tag in tags:
    if tag['Key'].lower() == 'owner' and "@" in tag['Value']:
      return tag['Value']
  return None
def send_email(email, user_name, keys):
  greeting = f"Dear {user_name}" if "@" not in user_name else "Dear User"
  body = f"""
  {greeting},
  This is a reminder that the following active AWS access keys have not been rotated in over 90 days:
  {', '.join(keys)}.
  For security compliance, please rotate your access keys at your earliest convenience.
  Instructions on how to rotate your keys can be found here:
   https://docs.aws.amazon.com/IAM/latest/UserGuide/id-credentials-access-keys-update.html
  Thank you,
  Your Security Team
  """
  try:
    ses.send_email(Source=sender_email, Destination={'ToAddresses': [email]},
            Message={'Subject': {'Data': "Action Required: Rotate Your AWS Access Keys"},
                'Body': {'Text': {'Data': body}}})
    return True
  except Exception as e:
    print(f"Failed to send email to {email} for user {user_name}: {e}")
    return False