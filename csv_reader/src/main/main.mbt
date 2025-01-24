pub fn main() {
  let csv_str = "name,age\nAlice,20\nBob,25";
  
  // 解析 CSV 字符串
  let data = @lib.from_string(csv_str);
  
  // 打印 CSV 表头
  println("Headers: " + @lib.join_with_comma(data.headers));
  
  // 打印第一行数据
  let first_row = data.rows.get(0).unwrap_or([]);
  println("First Row: " + @lib.join_with_comma(first_row));
  
  // 将表格数据转换为 CSV 字符串
  let new_csv_str = @lib.to_string(data);
  println("Reconstructed CSV:\n" + new_csv_str);
}
