# bash get-k-source.sh

# INPUT_FILE="../Unihan/Unihan_IRGSources.txt"
# head -n 66 "../Unihan/Unihan_IRGSources.txt" > "./test.txt" # 複製前100列當成測試資料
INPUT_FILE="./test.txt" # 如果要測試，可以生一個小一點的測試資料

list_kFields() {
  # -F'\t'設定使用Tab當成分隔符
  # {print} 可以抓印結果, 可以再使用$2表示取第二項數據
  # grep -v '^#' "$INPUT_FILE" | awk -F'\t' '{print $2}'

  # 提取所有第二列数据（跳过以 # 开头的行）
  types=$(
  grep -v '^#' "$INPUT_FILE" |
  awk -F'\t' '{print $2}' | sort | uniq
  )

  # return
  echo "$types"
}

# kCompatibilityVariant, kIICore, ..., kTotalStrokes
k_types=$(list_kFields)
echo -e '\033[44mlist kFields\033[0m'
for type in $k_types; do
    echo "\"$type\""
done

# 再篩選一次，只要kIRG的項目就好
# kSource=$(echo "$k_types" | tr ' ' '\n' | grep ^kIRG)
# echo "$kSource"

# 初始化結果
declare -A results

while IFS= read -r line; do
  # 跳過註解行
  ## =~ 是Bash的正則表達式運算
  [[ "$line" =~ ^# ]] && continue

  # 從每行獲取 Unicode 項目和類型
  unicode=$(echo "$line" | awk -F'\t' '{print $1}')
  echo "$unicode"
  key=$(echo "$line" | awk -F'\t' '{print $2}')
  value=$(echo "$line" | awk -F'\t' '{print $3}')

  # 如果 key 為 kIRG_*，提取對應的值 (例如 "T4-2224" 的前綴)
  if [[ "$key" =~ ^kIRG_ ]]; then
    prefix=$(echo "$value" | cut -d'-' -f1) # 取 T4、T6 等前綴
    results["$key"]+="$prefix "
  fi

done < "$INPUT_FILE"

# echo "$results" # <-- `declare -A results` 宣告了一個關聯數組，但你嘗試直接用 `echo "$results"` 打印整個數組，這是無效的。Bash 不支持直接打印關聯數組的方式，因此會導致輸出的 `$results` 看起來是空的
# 遍歷並打印關聯數組內容
echo -e '\033[44mResults:\033[0m'
for key in "${!results[@]}"; do
  echo "$key: ${results[$key]}"
done

echo "done"
