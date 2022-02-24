cd /d e:
pause
cd e:/WorkSpace/NodeProject/Blog
pause
hexo g
pause
hexo d
pause
git commit -m "Blog update at %date:~0,4%%date:~5,2%%date:~8,2%%time:~0,2%%time:~3,2%%time:~6,2%"
pause