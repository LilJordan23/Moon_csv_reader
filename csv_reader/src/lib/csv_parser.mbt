pub struct CsvData {
  headers: Array[String];
  rows: Array[Array[String]]
}

pub fn from_string(content: String) -> CsvData {
  let mut headers : Array[String] = []
  let  rows : Array[Array[String]] = []
  let mut line_start = 0
  
  // 手动分割行
  for i in 0..<content.length() {
    let ch = content[i]
    if ch == '\n' {
      if line_start < i {
        let line = content.substring(start=line_start, end=i)
        if headers.length() == 0 {
          headers = parse_line(line)
        } else {
          rows.push(parse_line(line))
        }
      }
      line_start = i + 1
    }
  }
  
  // 处理最后一行
  if line_start < content.length() {
    let last_line = content.substring(start=line_start, end=content.length())
    if headers.length() == 0 {
      headers = parse_line(last_line)
    } else {
      rows.push(parse_line(last_line))
    }
  }
  
  CsvData(headers, rows)
}

fn parse_line(line: String) -> Array[String] {
  let result : Array[String] = []
  let mut current = ""
  let mut in_quotes = false
  
  for i in 0..<line.length() {
    let ch = line[i]
    
    if ch == '"' {
      in_quotes = not(in_quotes)
    } else if ch == ',' && not(in_quotes) {
      result.push(current)
      current = ""
    } else {
      current = current + ch.to_string()
    }
  }
  
  // 添加最后一个字段
  result.push(current)
  
  result
}

pub fn join_with_comma(arr: Array[String]) -> String {
  let mut result = ""
  let mut first = true
  
  for item in arr {
    if first {
      result = item
      first = false
    } else {
      result = result + "," + item
    }
  }
  
  result
}

pub fn to_string(data: CsvData) -> String {
  let header_str = join_with_comma(data.headers)
  let mut result = header_str
  
  for row in data.rows {
    result = result + "\n" + join_with_comma(row)
  }
  
  result
}

test "parse_csv basic" {
  let input = "name,age\nAlice,20\nBob,25"
  let result = from_string(input)
  
  assert_eq!(result.headers, ["name", "age"])
  assert_eq!(result.rows, [["Alice", "20"], ["Bob", "25"]])
}

test "parse_csv with quotes" {
  let input = "name,description\n\"Smith, John\",\"Developer\"\n\"Doe, Jane\",\"Manager\""
  let result = from_string(input)
  
  assert_eq!(result.headers, ["name", "description"])
  assert_eq!(result.rows, [["Smith, John", "Developer"], ["Doe, Jane", "Manager"]])
}
