#!/bin/bash
###################################################################
#Script Name    :bucket-checker.sh
#Description    :Simple Script to check discoverability and
#                configutation of buckets relative to specific
#                threats
#Author         :Scott Isaac
#Email          :scott@notsosecure.com
###################################################################

if aws sts get-caller-identity >/dev/null
then
  pattern='(admin|administration|administrator|ads|alpha|android|angular|ansible|any|api|api-config|api-configs|apollo|app|app-img|apps|apt|asset|assetmanager|assets|attach|attachment|attachments|avatar|avatars|aws|awscloudtrail|awsfiles|awsiam|awslogs|aws-logs|awsmedia|awsprivate|awsroot|awss3|backgrounds|backup|backups|banner|banners|beta|betas|billing|binaries|blog|blog-assets|blogs|bucket|bugbounty|bugs|bugzilla|build|builds|bulletins|cache|caches|catalogue|cdn|cloud|cloudfront|cloudtrail|cloudtraillog|cloudtraillogs|cloudtrail-logs|cloudtrails|club|clubs|cluster|clusters|code-repo|com|company|conference|conferencing|confidential|config|configs|consultant|consultants|consulting|consumer|contact|content|contents|contracts|corporate|couk|customers|data|data_dump|data_dumps|data-export|data-exports|dataset|datasets|datawarehouse|data-warehouse|deliveryappstorage|delivery-app-storage|design|desk|dev|devcenter|devel|developer|developers|development|deveopers|dev-files|devops|dist|distribution|distributions|distro|doc|docker|docker-registry|docs|documentation|documents|download|downloads|driver|drivers|dump|editions|elasticache|elasticbeanstalk|elasticsearch|email|emails|engineer|engineering|event|events|export|exports|file|files|files-attachments|fileserv|fileserver|filestore|finance|forum|forums|frontend|galleries|gallery|gemini|general|git|github|graphite|graphql|help|helpcenter|helpcentre|helpmedia|html|hub|images|img|imgs|infra|internal|intranet|invalid|investor|investors|invoice|invoices|ios|iterable|kafka|kbfiles|kerberos|keynote|kibana|knowledgebase|lab|labs|landing|linux|loadbalancer|local|localhost|log|logexport|logos|logs|logstash|mac|mail|mails|main|main-storage|map|maps|marketing|marketing_assets|matrix|maven|media|mediadownloads|media-downloads|mediauploads|media-uploads|member|members|mercurial|misc|mobile|mobile-staging|net|newsletter|onboarding|opensource|operations|opinion|ops|package|packages|page|pages|partner|partners|pdf|pdfs|photo|photos|pics|picture|pictures|prerelease|prereleases|presentations|private|prod|production|production3|products|profile-photo|profile-photos|profiles|project|projects|public|rates|react|registry|releases|repo|reports|repositories|repository|research|reseller|reserved|resource|resources|rest|retail|retailer|retailers|s3|s3-attachemnts|s3connectortest|s3log|s3-log|s3logs|s3-logs|sales-app|sandbox|scdn|search|share|shared|shop|shops|signal|signals|signature|site|sites|sitestats|smoke|snapshot|snapshots|splunk|spreadsheets|stage|staging|static|statistics|stats|storage|store|studio|submission|submissions|subversion|support|support-attachments|supportdocs|supportmedia|supportuploads|temp|temporary|terraform|terraformbinaries|test|test-sandbox|theme|themekit|themes|tmp|toolbelt|tools|training|ui-staging|update|updates|upload|uploads|user-asset|user-assets|usercontent|user-files|users|vagrant|vanitydev|vanitydevelopment|vanityproduction|vanitystaging|video|videos|vms|vps|warehouse|web|webapp|webassets|web-assets|webdata|web-data|web-gstatic|website|websiteassets|website-assets|websites|webstatic|web-static|widget|widgets|windows|wordpress|www|wwwcache|zendesk)'
  buckets=$(aws s3 ls | cut -d" " -f3)
  echo -e "Starting anti-reconnaisance checks...\n\n"
  echo -e "The following buckets contain keywords used in common\ndictionaries:"
  grep -E --colour "$pattern" <<< $buckets
  echo -e "\nWith the right keywords these may be enumerated\nhttps://cloudsecwiki.com/aws_cloud.html#defensive"
  echo -e "Anti-reconnaisance checks COMPLETE!\n\n"
  echo -e "Starting anti-ransomware checks...\n\nChecking Bucket:"
  for i in $(echo -n $buckets)
  do
    echo "$i"
    vers=$(aws s3api get-bucket-versioning --bucket "$i")
    if ! grep '"Status": "Enabled"' <<< $vers > /dev/null
    then
      vb="$vb\n$i"
    elif ! grep '"MFADelete": "Enabled"' <<< $vers > /dev/null
    then
      mb="$mb\n$i"
    fi
  done
  echo -e "\n\nThe following buckets DO NOT have versioning enabled:
$vb\n\nThe following buckets DO NOT have MFA delete enabled:
$mb\n\nWithout versioning and MFA delete you may be vulnerable to
cloud native ransomware attacks\nhttps://rhinosecuritylabs.com/aws/s3-ransomware-part-1-attack-vector/\n"
else
  echo -e "Please authenticate using the aws commandline eg:\naws config"
fi
echo "Want to learn more about Cloud Security - We can help!
█████████████████████████████████████████
█████████████████████████████████████████
████ ▄▄▄▄▄ █▀█ █▄█ ▀ ▀ ▄ ▄▄▄██ ▄▄▄▄▄ ████
████ █   █ █▀▀▀█ ▀▀▄▄▀██▄▄  ▀█ █   █ ████
████ █▄▄▄█ █▀ █▀▀▀▄▀▀██▄  ▀▄▄█ █▄▄▄█ ████
████▄▄▄▄▄▄▄█▄▀ ▀▄█▄▀▄█▄▀▄▀ ▀ █▄▄▄▄▄▄▄████
████▄ ▄▄ █▄  ▄▀▄▀▄▄█ ▄█▀ ▀  ▄ ▀▄█▄▀ ▀████
████▄▄█▀██▄  █▄█▀█▀ ▀▄ ▀█▀████▀▀█▄▀▄█████
█████▄ ▄█▄▄ ▀▄▄█▄ ▄▄  ▀▀ ▀ ▀█▄▀▄▄▄█▀▀████
████▄▀█▄▀▄▄▄▀▀  ▄█▀ ▄█▄█ ▀▄▀▄▀█▄▀█▀▄█████
█████▀▄ ▄ ▄▄▀▄▄▄▀ ▄█▀▄█▀▀█▄  ▄▀▄▄▀█ ▀████
████▄▄▀▀▄▄▄  ▄▀█▀▄▄▄██▀▀█ ▀▀█▄ ▀▄▄▀▄█████
████    ▄▀▄▄ ▄██▄ ▄▄  █▀▀▀▄ ▄▄▀▄▄▀█ ▀████
████ █  ▀▄▄▀ █▀ ▄█▀  █▄█▄▀▀▀▀ █▄  ▀▄█████
████▄█▄▄█▄▄▄▀▀▄▄▀ ▄▄     ▀▄█ ▄▄▄  ▀█ ████
████ ▄▄▄▄▄ █▄▄██▀▄▄▄▄▄█▀▄    █▄█  ▀ ▀████
████ █   █ █  ▄█▄▄▄▄▀▄█▀▀▀ █▄ ▄   ▀██████
████ █▄▄▄█ █  █ ▄▄   ▄▄▀ ▀▀▄█ ▄▄▀ ▀▄█████
████▄▄▄▄▄▄▄█▄▄█▄▄██▄█▄█▄████▄████▄█▄█████
█████████████████████████████████████████"
