@echo off

start cmd /c "setx AWS_CA_BUNDLE ^"C:\Program Files\Amazon\AWSCLIV2\awscli\botocore\cacert.pem^""
hugo
aws s3 sync .\public\  s3://blog.fengidea.com.1
aws cloudfront create-invalidation --distribution-id E3Q0O3D0J34TN6 --paths "/*" 
pause 
