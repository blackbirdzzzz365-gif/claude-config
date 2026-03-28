# Team Conventions

## Auth MCP Tools — mỗi người tự làm trên máy của mình

Các tool sau cần auth lại trên TỪNG MÁY qua browser:
- **Figma**: Mở Claude Code → dùng tool Figma lần đầu → browser popup → login
- **BigQuery**: Dùng tool BigQuery → login Google account có quyền
- **Slack**: Login workspace
- **Google Calendar / Gmail**: Login Google account

Auth tokens được lưu LOCAL trên máy bạn.
Không share token. Không commit token.
Mỗi máy mới: auth 1 lần là đủ.

---

## Git branch naming
- `skill/ten-skill`      — thêm hoặc sửa skill
- `knowledge/mo-ta`      — cập nhật knowledge base
- `fix/mo-ta`            — sửa lỗi
- `feature/ten-feature`  — cho app repos

## Quy ước Pull Request
- Mọi thay đổi vào main qua Pull Request
- Assign ít nhất 1 người review và approve
- Không push trực tiếp vào main (kỷ luật team, không có enforcement)

---

## Cập nhật skills hàng ngày
```bash
cd ~/claude-config && git pull
```

---

## Quy ước dùng Claude Code

### Luôn có product context khi gọi skill
Trước khi dùng skill nào, hãy cho Claude biết context:
```
Sản phẩm: [tên sản phẩm]
Giai đoạn: [Early / Growth / Scale]
Target user: [mô tả ngắn]
OKR hiện tại: [Q? — objective]
Constraint: [deadline, team size, tech stack...]
```

### Session hygiene
- Dùng `/clear` giữa các task không liên quan nhau
- Sau ~50 tin nhắn, tạo handoff document để preserve context
- Factual claims (số liệu market size, competitor data) → verify trước khi publish

### Không commit thẳng vào main
Kể cả knowledge files. Tạo branch → PR → review → merge.

### Validate output trước khi dùng
Claude có thể hallucinate số liệu và competitor data.
Luôn cross-check với source thực trước khi đưa vào PRD hoặc presentation.

---

## Thư mục skills

Skills nằm flat trong `global/plugins/team-skills/skills/`:

| Thư mục | Ý nghĩa | Ai dùng |
|---------|---------|---------|
| `skills/<ten-skill>/` | Skills đã review, deploy cho cả team | Cả team |
| `skills/_lab/` | Thử nghiệm cá nhân, chưa review | Cá nhân — không tự deploy |
