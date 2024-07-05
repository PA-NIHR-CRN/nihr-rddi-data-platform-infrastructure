import sys
import logging
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ['JOB_NAME','input_path','output_path'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)
inputPath = args['input_path']
output_path = args['output_path']
log = logging.getLogger()
log.setLevel(logging.INFO)
log.info(inputPath)
log.info(output_path)

# Script generated for node Amazon S3
AmazonS3_node1718377480779 = glueContext.create_dynamic_frame.from_options(format_options={"multiline": False}, connection_type="s3", format="parquet", connection_options={"paths": [inputPath], "recurse": True}, transformation_ctx="AmazonS3_node1718377480779")

# Script generated for node Change Schema
ChangeSchema_node1718022958434 = ApplyMapping.apply(frame=AmazonS3_node1718377480779, mappings=[("name", "string", "name", "string"), ("email", "string", "email", "string"), ("resourcetype", "string", "resourcetype", "string"), ("id", "string", "id", "string"), ("type", "string", "type", "string"), ("timestamp", "string", "timestamp", "string")], transformation_ctx="ChangeSchema_node1718022958434")

# Script generated for node Amazon S3
AmazonS3_node1718023552361 = glueContext.write_dynamic_frame.from_options(frame=ChangeSchema_node1718022958434, connection_type="s3", format="glueparquet", connection_options={"path": output_path, "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_node1718023552361")

log.info(AmazonS3_node1718023552361)

job.commit()