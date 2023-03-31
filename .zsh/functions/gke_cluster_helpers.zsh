#! /usr/bin/env zsh

function describe_cluster {
  local -a proj loc usage
  zparseopts -D -E -F \
    p:=proj -project:=proj \
    l:=loc -location:=loc \
    h=usage -help=usage

  [[ -n ${usage-} ]] && {
    echo "${0} -p|--project <GCE project> -l|--location <GCE region> <GKE cluster name>";
    return 0
  }

  local cluster="${1}"
  [[ -z "${cluster-}" ]] && {
    echo "You must pass in a cluster name to check";
    echo "${0} -p|--project <GCE project> -l|--location <GCE region> <GKE cluster name>";
    return 1;
  }

  local project="${proj[-1]:-$(gcloud config get-value project 2>/dev/null)}"
  [[ -z "${project}" ]] && {
    echo "GCE Project is required. Set this via either:";
    echo "gcloud config set project <project_name>";
    echo "${0} -p|--project <GCE project> -l|--location <GCE region> <GKE cluster name>";
    return 1;
  }

  local location="${loc[-1]:-$(gcloud config get-value compute/region 2>/dev/null)}"
  [[ -z "${location}" ]] && {
    echo "GCE Region is required. Set this via either:";
    echo "gcloud config set compute/region <project_name>";
    echo "${0} -p|--project <GCE project> -l|--location <GCE region> <GKE cluster name>";
    return 1;
  }

  # Fetch the cluster data and run it through jq. If the cluster exists, print the important bits.
  "gcloud container clusters describe --project ${project} --region ${location} ${cluster} --format=json" | \
      jq --null-input --exit-status --raw-output \
        "inputs | if .status == \"RUNNING\" then \"Cluster: ${project}/${cluster} - started \(.createTime)\" else empty end" && \
    echo "View console: https://console.cloud.google.com/kubernetes/clusters/details/${location}/${cluster}?project=${project}\n"
}
