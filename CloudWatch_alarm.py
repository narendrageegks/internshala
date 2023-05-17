import boto3

def create_cloudwatch_alarm(instance_id):
    client = boto3.client('cloudwatch')
    
    alarm_name = 'HighCPUUsageAlarm'
    comparison_operator = 'GreaterThanOrEqualToThreshold'
    evaluation_periods = 5
    threshold = 80
    period = 60 
    statistic = 'Average'
    namespace = 'AWS/EC2'
    
    response = client.put_metric_alarm(
        AlarmName=alarm_name,
        ComparisonOperator=comparison_operator,
        EvaluationPeriods=evaluation_periods,
        Threshold=threshold,
        Period=period,
        Statistic=statistic,
        Namespace=namespace,
        MetricName='CPUUtilization',
        Dimensions=[
            {
                'Name': 'InstanceId',
                'Value': instance_id
            },
        ],
        AlarmDescription=alarm_description,
        ActionsEnabled=True
    )
    
    print('CloudWatch alarm created successfully.')

# Replace 'instance_id' with the actual ID of your EC2 instance
instance_id = 'yi-0567924d5627215ab'
create_cloudwatch_alarm(instance_id)
