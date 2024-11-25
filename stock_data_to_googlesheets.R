

# 第一次認證後，認證資訊會被儲存
# 可先在console執行以下，將會透過瀏覽器驗證Google帳戶
#library(googlesheets4)
#gs4_auth()



# 載入套件
library(googlesheets4)

symbol<- '2330.TW'

symbol_list<- c('2330.TW', '2317.TW', '2454.TW')
end_date <- Sys.Date()
start_date <- end_date-365

#先創建一個Google Sheet並貼上你的 Sheet ID,  ex: https://docs.google.com/spreadsheets/d/xxxooo
sheet_id <- "xxxooo"

# 載入外部類別: security_data.R計算均線, KD, RSI數值
source("stock_data_fetch.R")


options(gargle_oauth_cache = ".secrets")

# 讀取已存在的 spreadsheet
my_sheet <- read_sheet(sheet_id)

# 建立新的 spreadsheet
#my_sheet <- gs4_create("StockDataFrame1124")



update_my_sheet <- function(sheet_id, data, sheet_name = "工作表1", mode = "overwrite") {
  
  if (mode == "overwrite") {
    # 覆蓋整個工作表
    write_sheet(data, ss = sheet_id, sheet = sheet_name)
  } else if (mode == "append") {
    # 附加新資料
    sheet_append(ss = sheet_id, data = data, sheet = sheet_name)
  }
}


for (symbol in symbol_list) {
  
  stock <- stock_data_fetch(symbol, start_date, end_date)
  # xts 物件轉換時控制小數點
  my_df <- data.frame(
    date = index(stock),
    round(coredata(stock), digits = 2)
  )
  # 將 data frame 寫入以 symbol 為名稱的 Google Sheet:
  update_my_sheet(sheet_id=sheet_id, data=my_df, mode = "overwrite", sheet_name=symbol)
  
}
