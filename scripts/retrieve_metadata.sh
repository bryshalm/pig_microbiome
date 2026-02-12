mapfile -t projects < bioprojects.txt
total=${#projects[@]}
count=0

for bp in "${projects[@]}"; do
  count=$((count + 1))

  echo "Processing $bp..."

  esearch -db bioproject -query "$bp" \
  | elink -target sra \
  | efetch -format runinfo \
  > "${bp}_runinfo.csv"

  echo "$count of $total complete"
  echo "-----------------------------"
done
