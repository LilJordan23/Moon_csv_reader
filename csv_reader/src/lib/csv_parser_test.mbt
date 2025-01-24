test "csv parser test" {
  let csv_str = "name,age\nAlice,30\nBob,25"
  let data = from_string(csv_str)

  // 验证表头
  assert(data.headers == ["name", "age"], "表头解析错误")
  
  // 验证数据行
  assert(data.rows[0] == ["Alice", "30"], "第一行数据解析错误")
  assert(data.rows[1] == ["Bob", "25"], "第二行数据解析错误")
}