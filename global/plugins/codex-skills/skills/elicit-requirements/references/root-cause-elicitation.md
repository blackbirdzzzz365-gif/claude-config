# Root Cause Elicitation — Chi tiết & Ví dụ

## 5 Whys — Hướng dẫn thực hành

### Nguyên tắc
- Mỗi "Why" phải dựa trên **fact hoặc data**, không phải opinion
- Nếu 1 "Why" có nhiều answer → **fork thành nhiều chain**
- Dừng khi đến nguyên nhân **có thể action được** (thay đổi process, policy, system)
- Không dừng ở "do con người sai" — hỏi tiếp: "Tại sao hệ thống cho phép sai?"

### Ví dụ 1: E-commerce — Đơn hàng bị hủy nhiều

```
Problem: 25% đơn hàng bị hủy trong 24h đầu

Why 1: Tại sao khách hủy đơn?
→ Khách đặt nhầm sản phẩm (40%) | Thời gian giao quá lâu (35%) | Tìm được giá rẻ hơn (25%)

--- Nhánh A: Đặt nhầm sản phẩm ---
Why 2: Tại sao đặt nhầm?
→ Thông tin sản phẩm không rõ ràng trên mobile
Why 3: Tại sao không rõ?
→ Ảnh nhỏ, spec bị cắt trên màn hình nhỏ
Why 4: Tại sao thiết kế mobile kém?
→ Product page chưa bao giờ được optimize cho mobile
Root cause: Thiếu mobile-first design cho product detail page

--- Nhánh B: Giao hàng lâu ---
Why 2: Tại sao giao lâu?
→ Estimated delivery hiện 5-7 ngày, khách kỳ vọng 2-3 ngày
Why 3: Tại sao estimate cao?
→ Dùng estimate mặc định, không tính theo kho gần nhất
Root cause: Thiếu logic tính ETA dựa trên vị trí kho
```

### Ví dụ 2: SaaS — User không complete onboarding

```
Problem: 60% user drop off tại bước 3 của onboarding

Why 1: Bước 3 yêu cầu gì?
→ Import data từ hệ thống cũ
Why 2: Tại sao user không import?
→ Chỉ hỗ trợ CSV, user dùng Excel/Google Sheets
Why 3: Tại sao chỉ hỗ trợ CSV?
→ MVP chỉ build CSV parser, chưa mở rộng
Why 4: Tại sao chưa mở rộng?
→ Không biết user dùng format nào nhiều nhất
Root cause: Thiếu data về user's existing tools → thiếu import format phù hợp
```

## Fishbone (Ishikawa) — Cách dùng

### Khi nào dùng Fishbone thay vì 5 Whys thuần?
- Problem có **nhiều contributing factors** cùng lúc
- Cần **visualize** mối quan hệ giữa các nguyên nhân
- Team workshop — giúp mọi người brainstorm theo category

### 6 Categories chuẩn cho software/product:

| Category | Ví dụ câu hỏi |
|----------|---------------|
| **People** | Ai liên quan? Training đủ chưa? Workload hợp lý? |
| **Process** | Quy trình có tồn tại? Có được follow? Bottleneck ở đâu? |
| **Technology** | System có đáp ứng? Performance? Integration issues? |
| **Policy** | Policy nào cản trở? Compliance requirement nào? |
| **Data** | Data đủ chưa? Chính xác không? Accessible? |
| **External** | Market changes? Vendor issues? Regulatory changes? |

### Template

```
                    ┌─ People ──── [cause] ─── [sub-cause]
                    │
                    ├─ Process ─── [cause] ─── [sub-cause]
                    │
[PROBLEM] ◄─────── ├─ Technology ─ [cause]
                    │
                    ├─ Policy ──── [cause]
                    │
                    ├─ Data ────── [cause] ─── [sub-cause]
                    │
                    └─ External ── [cause]
```

## Validation Checklist

Sau khi tìm root cause, validate bằng 3 câu hỏi:

1. **Necessity test:** "Nếu root cause này KHÔNG tồn tại, problem có xảy ra không?"
   - Nếu CÓ → đây không phải root cause thực sự, đào tiếp
   - Nếu KHÔNG → confirmed root cause

2. **Sufficiency test:** "Fix root cause này ALONE có đủ để giải quyết problem không?"
   - Nếu CÓ → single root cause
   - Nếu KHÔNG → có contributing factors khác, cần fix combo

3. **Actionability test:** "Team có thể thay đổi root cause này không?"
   - Nếu CÓ → actionable requirement
   - Nếu KHÔNG → escalate hoặc tìm workaround

## Kết hợp với các chế độ khác

- Root cause → **JTBD Interview**: Khi root cause liên quan đến user behavior
- Root cause → **Clarification**: Khi root cause rõ, cần refine thành specific requirements
- Root cause → **Pre-mortem** (critical-thinking skill): Khi root cause reveal systemic risk
