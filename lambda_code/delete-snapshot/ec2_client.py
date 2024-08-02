import boto3

def get_ec2_client(credentials, region):
    region=region
    ec2 = boto3.client('ec2',
                              aws_access_key_id=credentials['AccessKeyId'],
                              aws_secret_access_key=credentials['SecretAccessKey'],
                              aws_session_token=credentials['SessionToken'],
                              region_name=region)
    return ec2