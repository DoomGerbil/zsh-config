function awsid {
    echo AWS_PROFILE="${AWS_PROFILE}"
    aws sts get-caller-identity
  }
