@echo off


hugo
ossutil64.exe sync -u ./public/ oss://blog-fengidea-com

pause 
