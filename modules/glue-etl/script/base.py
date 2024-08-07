import sys
import logging
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.dynamicframe import DynamicFrame
from awsglue.job import Job
import gs_now

def setup(args):
    input_path = args['input_path']
    output_path = args['output_path']
    stage = args['stage']
    log = logging.getLogger()
    log.setLevel(logging.INFO)
    log.info(input_path)
    log.info(output_path)
    return input_path,output_path, stage

def transform(input_path, stage, ctx):
    AmazonS3_node1718377480779 = ctx.create_dynamic_frame.from_options(format_options={"multiline": False}, connection_type="s3", format="parquet", connection_options={"paths": [input_path], "recurse": True}, transformation_ctx="AmazonS3_node1718377480779")

    # <!--- PUT YOUR TRANSFORMS HERE -->
    # Source node shoudl attach to your first transform. 
    
    # Script generated for node Add Current Timestamp
    # gs_now and other glue transforms attach directly to the DataFrame - df
    df = AmazonS3_node1718377480779.toDF()
    df = df.gs_now(colName=f"{stage}_timestamp")
    AddCurrentTimestamp_node1720445890121 = DynamicFrame.fromDF(df,ctx,"AddCurrentTimestamp_node1720445890121")
    # </>
    # Return your final transform node, this will write it out to the next bucket stage
    # Returned value must be a DynamicFrame
    return AddCurrentTimestamp_node1720445890121

def main():
    args = getResolvedOptions(sys.argv, ['JOB_NAME','input_path','output_path','stage'])
    sc = SparkContext()
    glueContext = GlueContext(sc)
    spark = glueContext.spark_session
    job = Job(glueContext)
    job.init(args['JOB_NAME'], args)
    input_path,out_path, stage = setup(args)
    transforms = transform(input_path,stage,glueContext)

    output_node = glueContext.write_dynamic_frame.from_options(frame=transforms, connection_type="s3", format="glueparquet", connection_options={"path": out_path, "partitionKeys": []}, format_options={"compression": "snappy"}, transformation_ctx="output_node")
    job.commit()

main()

# job.commit()
