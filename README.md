# Google Sheets Edit Library

Developed for a University project, this library functions as a tool for editing sheets within Google Sheets.

## Features
- Returns a two-dimensional array with table values.
- You can access a row with `t.row(1)`
- The `each` function from Enumerable is implemented, returning all cells within the table from left to right.
- With `t["Column name"]` you will get column data.
- Returns an entire column when querying `t["First Column"]`
- Allows access to values within a column using the following syntax: `t["First Column"][1]` for accessing the second element of that column.
- Enables the adjustment of values within a cell using the following syntax: `t["First Column"][1] = 2556`.
- Enables direct access to columns through corresponding methods.
`t.firstColumn, t.secondColumn, t.thirdColumn`.
- Subtotal/Average for certain columns can be calculated using the following syntax: `t.firstColumn.sum and t.firstColumn.avg`.
- From each column, an individual row can be extracted based on the value of one of the cells. (Assuming that cell uniquely identifies that row). Syntax example: `t.index.rn2310`, this code will return the row of the student whose index is rn2310.
- Supports functions such as map, select, reduce. For example: `t.firstColumn.map { |cell| cell += 1 }`
- Ignores rows with keywords TOTAL and SUBTOTAL
- Ignores rows with no data
- Adding two tables as long as their headers are the same. For example, `t1 + t2`, where each represents a table within one of the worksheets. The result will return a new table where the rows (excluding the header) of t2 are added within t1. (Similar to SQL UNION operation)
- Subtracting two tables is possible as long as their headers are the same. For example, `t1 - t2`, where each represents a representation of one of the worksheets. The result will return a new table where all rows from t2 are removed from t1 if they are identical.