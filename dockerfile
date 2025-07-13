# 使用一個輕量的 Alpine Linux 作為基礎映像
FROM alpine:latest

# 作者資訊 (可選)
LABEL maintainer="your-name"

# 設定 PocketBase 的版本和下載 URL
# 你可以到 https://github.com/pocketbase/pocketbase/releases 查詢最新版本
ARG PB_VERSION=0.28.4
ARG PB_URL="https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip"

# 安裝 wget 和 unzip 以下載並解壓縮 PocketBase
RUN apk add --no-cache wget unzip

# 下載並解壓縮 PocketBase 到 /app 資料夾
RUN wget -q ${PB_URL} -O /tmp/pb.zip && \
    unzip /tmp/pb.zip -d /app && \
    rm /tmp/pb.zip

# 設定工作目錄
WORKDIR /app

# 將你的資料掛載到這個路徑。Render 會將持久化硬碟掛載到這裡。
VOLUME /app/pb_data

# 開放 8080 port，PocketBase 預設會在這個 port 啟動
EXPOSE 8080

# 啟動 PocketBase 服務的命令
# --dir 指定資料儲存的位置
# --host 監聽來自任何 IP 的請求
CMD ["./pocketbase", "serve", "--host=0.0.0.0", "--port=8080", "--dir=/app/pb_data"]
