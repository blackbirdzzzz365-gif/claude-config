# Browser Runtime Notes

Tóm tắt ngắn các ghi nhận đã verify từ tài liệu chính thức trước khi chọn browser/runtime.

## Playwright

Nguồn chính:
- `https://playwright.dev/python/docs/auth`
- `https://playwright.dev/python/docs/release-notes`

Điểm quan trọng:
- Playwright hỗ trợ lưu và nạp lại authenticated state bằng `browser_context.storage_state()`
- Auth state nên để ngoài repo và thêm vào `.gitignore`
- Playwright 1.51 có thêm option `indexed_db=True` khi lưu `storage_state`, hữu ích nếu auth phụ thuộc IndexedDB

Kết luận:
- Dùng Playwright làm baseline abstraction là hợp lý
- Session/auth state nên là primitive đầu tiên cần chuẩn hóa

## browser-use

Nguồn chính:
- `https://github.com/browser-use/browser-use`

Điểm quan trọng:
- Open source, MIT license
- Hỗ trợ agent browser workflow, custom tools, auth examples
- Chính project này khuyến nghị cloud/browser infra riêng cho stealth, proxy rotation, CAPTCHA solving ở production

Kết luận:
- Phù hợp cho dynamic browser tasks nơi DOM thay đổi thường xuyên
- Không nên lạm dụng cho mọi bước; dùng selective cho task cần adaptability

## Camoufox

Nguồn chính:
- `https://github.com/daijro/camoufox`
- `https://github.com/daijro`

Điểm quan trọng:
- Dự án tập trung vào anti-detect browser cho Playwright/Firefox
- Repo nhấn mạnh khả năng che automation traces
- Maintainer profile ghi rõ có giai đoạn gián đoạn bảo trì sau medical emergency trong năm 2025
- Repo public cho thấy release mới nhất được hiển thị là giữa tháng 3 năm 2025 tại thời điểm review

Suy luận:
- Có rủi ro maintainability và drift theo thời gian nếu architecture phụ thuộc cứng vào Camoufox-specific behavior

Kết luận:
- Có thể là runtime thử nghiệm hữu ích cho anti-detection
- Không nên khóa chặt toàn architecture vào Camoufox assumptions
- Nên đặt sau interface/feature flag để có thể fallback sang runtime khác

## Recommendation

### Baseline

- Dùng Playwright abstractions + `storage_state`
- Tách session management khỏi business logic

### Dynamic extraction/navigation

- Dùng browser agent cho:
  - search results
  - crawl feed
  - comment extraction
  - modal handling

### Production hardening

- Tách riêng:
  - browser runtime choice
  - stealth strategy
  - proxy strategy
  - account health monitoring

Không để domain services phụ thuộc trực tiếp vào một anti-detect implementation duy nhất.
