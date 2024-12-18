# bash update.sh 16.0.0

version=$1

show-err-msg() {
  local msg=$1
  echo -e "\033[41m$msg\033[0m"
}

if [ -z "$version" ]; then
  show-err-msg "請輸入版號"
  exit 1
fi

echo -e "\033[44m$version\033[0m"

wget "https://www.unicode.org/Public/$version/ucd/Unihan.zip"
unzip -v ./*.zip # 僅查看
# unzip -vo ./*.zip # 錯誤，加入-v其實的-o就會無效
unzip -o ./*.zip # 解壓 -o 強製覆蓋

# 查看檔案大小
du -h ./*.txt

rm *.zip
