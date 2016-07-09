#!/bin/bash
if [ $1 ]; then
       pname=800
       echo "项目名称为$pname"
       else
       pname='web'
       echo "没有定义项目名称, 默认为$pname"
fi
