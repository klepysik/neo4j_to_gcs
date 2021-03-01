#!/usr/bin/python

import boto3

ec2 = boto3.resource('ec2', region_name='region_name',aws_access_key_id='id',aws_secret_access_key='key')
client = boto3.client('ec2', region_name='region_name',aws_access_key_id='id',aws_secret_access_key='key')


####SG check Find if relevant SG exists in VPC
sg_response=client.describe_security_groups(
    Filters=[
        {
            'Name': 'group-name',
            'Values': [
                'name_of_group',
            ]
        },
    ]
)

####Go over each VPC and verify that SG exists and if not create it.
for vpc in ec2.vpcs.all():
    print("Checking VPC: ",vpc.id)

    sgFound=False
    for sg_object in sg_response['SecurityGroups']:
        print("SG VPC: ", sg_object['VpcId'])
        if sg_object['VpcId']==vpc.id:
          print("SG exists")
          sgFound=True

    if not sgFound:
      print('No SG found, creating new SG group in', vpc.id)
      group = ec2.create_security_group(GroupName='name_of_group',Description='name_of_group',VpcId=vpc.id)
