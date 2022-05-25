@echo off


hugo
ossutil64.exe sync -u ./public/ oss://blog-fengidea-com
aliyun.exe cdn RefreshObjectCaches --ObjectPath https://blog.fengidea.com/
pause 
