@echo off


hugo
ossutil64.exe sync -u ./public/ oss://blog-penai-tech
aliyun.exe cdn RefreshObjectCaches --ObjectPath https://blog.penai.tech/
pause 
