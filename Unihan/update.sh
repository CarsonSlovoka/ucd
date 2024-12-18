# bash update.sh

show-err-msg() {
  local msg=$1
  echo -e "\033[41m$msg\033[0m"
}

# 定義 URL
URL="https://www.unicode.org/Public/"

available_version=$(curl -s $URL |
# <a href="12.1.0/">12.1.0/</a>
# (?<=<a href="): 匹配 `<a href="` 后的内容，但不包括 `<a href=`
grep -oP '(?<=<a href=").*?(?=/")' | # -o 只輸出匹配的內容而不是整列, -P:啟用正則表達式(Perl兼容PCRE)
grep -E '^[0-9]+\.[0-9]+(\.[0-9]+)?$') # 16.0.0

# 打印所有發現的版本
echo "網頁中可用的版本號:"
echo "$available_version"

# 從用戶獲取輸入的版本號
read -p "請輸入 Unicode 版本號 (例如: 15.1.0):" version

# 檢查輸入的版本號是否存在於列表中
if echo "$available_version" | grep -q "^$version\$"; then
    echo -e "\033[44m$version\033[0m"
else
    echo "輸入的版本號 $version 不在網頁列表中！"
    exit 1
fi

wget "https://www.unicode.org/Public/$version/ucd/Unihan.zip"
unzip -v ./*.zip # 僅查看
# unzip -vo ./*.zip # 錯誤，加入-v其實的-o就會無效
unzip -o ./*.zip # 解壓 -o 強製覆蓋

# 查看檔案大小
du -h ./*.txt

rm *.zip
