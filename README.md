gcloud installation : https://cloud.google.com/storage/docs/gsutil_install#linux
Enter the following at a command prompt:
curl https://sdk.cloud.google.com | bash
Restart your shell:
exec -l $SHELL
Run gcloud init to initialize the gcloud environment:
gcloud init


Need to verify that environment variable set to the place where script placed, if not set it :
# cat /etc/environment
NEO4J_GCS_UPLOAD_BUCKET=neo_backup/xxx

EXPORT NEO4J_GCS_UPLOAD_BUCKET=/neo_backup/xxx


Possible issues :
if folowing error exists - ImportError: No module named google_compute_engine
Run : # sudo rm -f /etc/boto.cfg
