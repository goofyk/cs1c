from minio import Minio
from minio.error import S3Error
import sys

def create_minio_bucket(endpoint, access_key, secret_key, bucket_name, region):
    try:
        client = Minio(
            endpoint,
            access_key=access_key,
            secret_key=secret_key,
            secure=False
        )

        if not client.bucket_exists(bucket_name):
            client.make_bucket(bucket_name, location=region)
            print(f"Bucket '{bucket_name}' created successfully.")
        else:
            print(f"Bucket '{bucket_name}' already exists.")

    except S3Error as e:
        print(f"Error creating bucket: {e}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

if __name__ == "__main__":
    minio_endpoint = sys.argv[1]
    minio_access_key = sys.argv[2]
    minio_secret_key = sys.argv[3]
    new_bucket_name = sys.argv[4]
    region = sys.argv[5]
    create_minio_bucket(minio_endpoint, minio_access_key, minio_secret_key, new_bucket_name, region)