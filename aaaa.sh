#!/bin/bash



str="hello world i like you babalala"  

echo $str | awk -F' ' '{print $1}' 
