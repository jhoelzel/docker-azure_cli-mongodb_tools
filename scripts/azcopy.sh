export AZURE_STORAGE_ACCOUNT='PUT_YOUR_STORAGE_ACCOUNT_HERE'
export AZURE_STORAGE_ACCESS_KEY='PUT_YOUR_ACCESS_KEY_HERE'

export container_name='backups'
export source_folder='/var/backups/*'
export destination_folder='backups/2022/'


for f in $source_folder
do
  echo "Uploading $f file..."
  azure storage blob upload $f $container_name $destination_folder$(basename $f)
done

echo "List all blobs in container..."
azure storage blob list $container_name

echo "Completed"
