if [[ -z GITLAB_ACCESS_TOKEN ]]
then
  echo "Missing GITLAB_ACCESS_TOKEN env var"
  exit 1
fi

terraform init \
    -reconfigure \
    -backend-config="address=$TF_ADDRESS" \
    -backend-config="lock_address=$TF_ADDRESS/lock" \
    -backend-config="unlock_address=$TF_ADDRESS/lock" \
    -backend-config="username=$TF_USERNAME" \
    -backend-config="password=$GITLAB_ACCESS_TOKEN" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"
    
