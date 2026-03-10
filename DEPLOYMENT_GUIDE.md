# Smart Dine Manager - 部署指南

## 📦 項目備份下載

**下載連結**: https://www.genspark.ai/api/files/s/RkFKd4mL

**檔案大小**: 916 KB (已壓縮)

---

## 🚀 永久部署方案

### 方案 A: GitHub Pages (推薦) ⭐

#### 步驟 1: 下載並解壓專案
```bash
# 下載備份檔案
wget https://www.genspark.ai/api/files/s/RkFKd4mL -O smart_dine_manager.tar.gz

# 解壓到指定目錄
tar -xzf smart_dine_manager.tar.gz
cd home/user/flutter_app
```

#### 步驟 2: 初始化 Git 並推送到 GitHub
```bash
# 初始化 git (如果還沒有的話)
git init
git add .
git commit -m "Initial commit: Smart Dine Manager"

# 連接到 GitHub repository
# 請先在 GitHub 創建一個新的 repository
git remote add origin https://github.com/YOUR_USERNAME/smart-dine-manager.git
git branch -M main
git push -u origin main
```

#### 步驟 3: 部署到 GitHub Pages
```bash
# 方法 1: 使用 GitHub Actions (自動化)
# 創建 .github/workflows/deploy.yml

mkdir -p .github/workflows
cat > .github/workflows/deploy.yml << 'YAML'
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.35.4'
      
      - name: Build Web
        run: |
          flutter pub get
          flutter build web --release --base-href=/smart-dine-manager/
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
YAML

git add .github/workflows/deploy.yml
git commit -m "Add GitHub Pages deployment workflow"
git push
```

#### 步驟 4: 啟用 GitHub Pages
1. 前往 GitHub repository 設定頁面
2. 找到 "Pages" 選項
3. Source 選擇 "gh-pages" 分支
4. 點擊 Save

**完成後,您的網址會是**:
```
https://YOUR_USERNAME.github.io/smart-dine-manager/
```

---

### 方案 B: Cloudflare Pages (更快速) ⭐⭐

#### 步驟 1: 準備專案
```bash
# 確保 build/web 目錄存在且為最新
cd /path/to/flutter_app
flutter build web --release
```

#### 步驟 2: 部署到 Cloudflare Pages

**選項 2-1: 使用 Wrangler CLI**
```bash
# 安裝 Wrangler
npm install -g wrangler

# 登入 Cloudflare
wrangler login

# 部署 (從 build/web 目錄)
cd build/web
wrangler pages deploy . --project-name=smart-dine-manager
```

**選項 2-2: 使用 Cloudflare Dashboard (最簡單)**
1. 前往 https://dash.cloudflare.com/
2. 選擇 "Pages"
3. 點擊 "Create a project"
4. 選擇 "Upload assets"
5. 上傳 `build/web` 目錄內的所有檔案
6. 項目名稱: smart-dine-manager

**完成後,您的網址會是**:
```
https://smart-dine-manager.pages.dev
```

---

### 方案 C: Vercel (備選方案)

```bash
# 安裝 Vercel CLI
npm install -g vercel

# 部署
cd /path/to/flutter_app/build/web
vercel --prod
```

**完成後會得到類似**:
```
https://smart-dine-manager.vercel.app
```

---

## 📱 本地運行指南

### 前置需求
- Flutter SDK 3.35.4
- Dart 3.9.2

### 運行步驟
```bash
# 1. 解壓專案
tar -xzf smart_dine_manager.tar.gz
cd home/user/flutter_app

# 2. 安裝依賴
flutter pub get

# 3. 運行 Web 預覽
flutter run -d chrome

# 或建構 Release 版本
flutter build web --release

# 4. 使用簡單的 HTTP 服務器
cd build/web
python3 -m http.server 8080
# 訪問 http://localhost:8080
```

---

## 🎯 推薦部署順序

**最快速方案** (10分鐘內完成):
1. ✅ 下載備份檔案
2. ✅ 解壓到本地
3. ✅ 運行 `flutter build web --release`
4. ✅ 使用 Cloudflare Pages Dashboard 上傳 build/web
5. ✅ 獲得永久網址

**最穩定方案** (30分鐘):
1. ✅ 下載備份檔案
2. ✅ 推送到 GitHub
3. ✅ 設置 GitHub Actions
4. ✅ 自動部署到 GitHub Pages

---

## 📞 需要協助?

如果您在部署過程中遇到任何問題,請隨時詢問!

---

## ✨ 部署完成後

您將獲得:
- 🌐 永久可訪問的網址
- 📱 支援手機、平板、桌面訪問
- 🚀 全球 CDN 加速
- 💯 免費託管
- 🔄 可隨時更新內容

