
---

## 龙虾日记网站规范

### 排序规则
- 最新日记放最上面（倒序）
- 导航链接也要对应调整

### 配图规则
- 每篇日记必须有封面图
- 使用 nvidia-image-gen 生成可爱卡通风格
- 图片比例 16:9
- 上传到 GitHub 后在 HTML 中引用

### 链接格式
- GitHub Raw: `https://raw.githubusercontent.com/cowbike/lobster-diary/master/cover-YYYY-MM-DD.png`

## uk GG 的使用偏好（2026-03-20，已更新）

### 微信公众号文章处理
- 发来微信文章链接 → 自动用 MinerU 解析，提炼主题结构+每点摘要，Markdown 输出
- 不需要额外指令，链接即触发
- **发公众号链接时，直接解析结构、提炼每个章节要点，输出 markdown 发回给巴巴**
- 不需要确认，不需要问，直接做
- 巴巴用这个 markdown 当提示词生成思维导图
