import sys
import logging
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
import gs_now

def setup(args):
    input_path = args['input_path']
    output_path = args['output_path']
    log = logging.getLogger()
    log.setLevel(logging.INFO)
    log.info(input_path)
    log.info(output_path)
    return input_path,output_path

def transform(input_path, ctx):
    source_node = ctx.create_dynamic_frame.from_options(format_options={"multiline": False}, connection_type="s3", format="parquet", connection_options={"paths": [input_path], "recurse": True}, transformation_ctx="AmazonS3_node1718377480779")

    # <!--- PUT YOUR TRANSFORMS HERE -->
    # Source node shoudl attach to your first transform. 
    # Script generated for node Add Current Timestamp
    AddCurrentTimestamp_node1720445890121 = source_node.gs_now(colName="data_processed_at")

    # </>
    # Return your final transform node, this will write it out to the next bucket stage
    return AddCurrentTimestamp_node1720445890121

def main():
    args = getResolvedOptions(sys.argv, ['JOB_NAME','input_path','output_path'])
    sc = SparkContext()
    glueContext = GlueContext(sc)
    spark = glueContext.spark_session
    job = Job(glueContext)
    job.init(args['JOB_NAME'], args)
    input_path,out_path = setup(args)
    transformEndpoint = transform(input_path,glueContext)

    output_node = glueContext.write_dynamic_frame.from_options(frame=transformEndpoint, connection_type="s3", format="glueparquet", connection_options={"path": out_path, "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="AmazonS3_node1720446021764")
    job.commit()

main()

