# 復刻 Citiesocial 

- 網址: https://david-practice-my-citiesocial.herokuapp.com/
  - 串接第三方登入:**Google** 及 **Facebook**
  - 付費串接**Line Pay**結帳
  - 分前後台:前台客戶下單頁面，後台商品管理上架
  - 購物車使用 **TDD** 方式開發
  - 搜尋商品標題
  - 部署到 Heroku，上傳儲存空間串接 [Amazon S3](https://aws.amazon.com/tw/s3/)
  

- 前台及後台
  - 前台: `https://david-practice-my-citiesocial.herokuapp.com/`
  - 後台: `https://david-practice-my-citiesocial.herokuapp.com/admin`
- 前台
  - 會員功能
    - 第三方登入: google 及 Facebook 登入
    - 個人資料編輯
    - 訂單紀錄
    - 後台管理
  - 購物車
    - 結帳金流: Line Pay 
  - 商品列表
    - 首頁跑馬燈顯示商品(隨機挑選六樣商品)
    - 依分類列表
  - 訂閱電子報
- 後台
  - 商品列表
    - 新增修改刪除商品
    - 商品照片上傳
    - 商品分類
    - 新增商品品項
    - 文章編輯器
    - 商品可勾選是否上架
  - 分類列表
    - 新增修改刪除分類(可拖拉排序)
  - 廠商列表
    - 新增修改刪除廠商
- 已存在帳號
  - 帳號: test_no1@gmail.com  
    密碼: 123456  
  - 帳號: test_no2@gmail.com  
    密碼: 123456  
  - 帳號: test_no3@gmail.com  
    密碼: 123456  

## 開發
- 前端：Bulma, SCSS, Stimulus.js
- 後端：Rails(6.0.3.2), PostgreSQL
- 部署: Heroku, Amaron S3
- 原始碼管理: GitHub  


## 使用套件及第三方服務
- 會員功能: [Devise](https://github.com/heartcombo/devise)
- 第三方登入: 
  - Google: [omniauth-google-oauth2](https://rubygems.org/gems/omniauth-google-oauth2)
  - **Facebook:** [omniauth-facebook](https://rubygems.org/gems/omniauth-facebook)
- Amazon S3 儲存空間:  [aws-sdk-s3](https://github.com/aws/aws-sdk-ruby)
- CSS Framework: [Bulma](https://bulma.io/)
- 物件使用軟刪除: [paranoia](https://github.com/rubysherpas/paranoia)
  - 要刪除的物件只標記為刪除,實際還存留在資料庫中.
- 前端打包: [Webpacker](https://github.com/rails/webpacker)
- 前端 JavaScript: [Stimulus.js](https://stimulusjs.org/)
- 管理敏感資訊: [figaro](https://github.com/laserlemon/figaro)
  - google 第三方登入相關資訊
  - Facebook 第三方登入相關資訊
  - Line Pay 相關資訊
- 訂單編號: [friendly_id](https://github.com/norman/friendly_id)
  - 以亂數產生訂單編號
  - 以亂數產生商品編號
- 管理 Procfile 套件: [foreman](https://github.com/ddollar/foreman)
  - 執行 web server
  - 開發時執行 webpack-dev-server
- icon: [font awesome](https://fontawesome.com/)
- 文字編輯器: Rails 6 引進的 [Action Text](https://guides.rubyonrails.org/action_text_overview.html)
- 管理物制列表:[acts_as_list](https://github.com/brendon/acts_as_list)
  - 後台分類列表的排序
- 前端拖拉功能(js 套件): [Sortable](https://github.com/SortableJS/Sortable)
  - 讓前台分類列表可以拖拉改變排序
- 測試套件: [rspec-rails](https://github.com/rspec/rspec-rails)
  - 購物車是以 TDD 方式完成
- 以 **factory method pattern**概念來做測試
  - 產生測試需要的假資料: [fake](https://github.com/faker-ruby/faker)
  - 快速產生`廠商`、`商品`...等物件: [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
- 用 post 方法送出資料: [Faraday](https://github.com/lostisland/faraday)
  - Line Pay 結帳時,相關資訊要以`post`的方式打到 line 伺服器
- 有限狀態機:[AASM](https://github.com/aasm/aasm)
  - 控制訂單的狀態: 已付款,未付款,運送中,取消
- 結帳金流: Line Pay 