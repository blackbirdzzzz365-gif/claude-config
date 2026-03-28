# Pragmatic Mode Integration

## Khi nào dùng

Check `.architecture/config.yml`:

```yaml
pragmatic_mode:
  enabled: true
  intensity: strict | balanced | lenient
  applies_to:
    - reviews
```

**Nếu `enabled: true` VÀ `reviews` trong `applies_to`**: Include Pragmatic Enforcer.

---

## Pragmatic Enforcer Review Format

Thêm phần này sau mỗi member's recommendations:

```markdown
#### Pragmatic Enforcer Analysis

**Mode**: [Strict | Balanced | Lenient]

##### Recommendation: [Recommendation Title]

**Necessity Assessment** (0-10):
- **Current need**: [Có đang solve concrete problem không?]
- **Future need**: [Likelihood và timeframe thực sự cần]
- **Cost of waiting**: [Hỏng gì nếu defer? Cost implement sau?]
- **Evidence**: [Concrete evidence justify việc làm ngay?]
- **Score**: [X/10]

**Complexity Assessment** (0-10):
- **Added complexity**: [Complexity introduce vào hệ thống]
- **Maintenance burden**: [Ongoing cost]
- **Learning curve**: [Impact tới team]
- **Score**: [X/10]

**Simpler Alternative**:
[Propose simpler approach meeting current requirements, hoặc explain tại sao đây đã là minimal]

**Pragmatic Recommendation**:
- ✅ **Implement now**: Clear current need, appropriate complexity
- ⚠️ **Simplified version**: Implement minimal version, defer bells and whistles
- ⏸️ **Defer**: Wait for trigger conditions
- ❌ **Skip**: Not needed, over-engineering

**Justification**: [Clear reasoning]

**If Deferring**:
- **Trigger conditions**: [Khi nào thì implement?]
- **Minimal alternative**: [Simplest thing that works now?]

**Pragmatic Score**:
- Necessity: [X/10] | Complexity: [X/10] | Ratio: [C/N = X.X]
- Target: Strict <1.0 | Balanced <1.5 | Lenient <2.0
- **Assessment**: Appropriate | Over-engineering | Under-engineering
```

---

## Intensity Levels

### Strict (Ratio <1.0)

Challenge mọi abstraction. Defer anything speculative. Require concrete evidence. Favor simple, direct solutions.

**Dùng khi**: MVP, tight timeline, small team, prototype.

### Balanced (Ratio <1.5)

Allow appropriate abstractions. Accept moderate complexity cho clear benefits. Balance pragmatism với code quality.

**Dùng khi**: Normal development, sustainable pace.

### Lenient (Ratio <2.0)

Allow strategic complexity. Accept abstractions cho anticipated growth. Consider longer time horizons.

**Dùng khi**: Building platforms, long-term infrastructure, established teams.

---

## Examples

### Example 1: Redis Caching (Balanced Mode)

**Recommendation**: "Add Redis caching layer for all DB queries"

**Necessity**: 7/10 — Page load 500ms, target <200ms, 60% duplicate queries
**Complexity**: 6/10 — Redis dependency, cache invalidation, ops
**Ratio**: 0.86

**Result**: ⚠️ Simplified version — Start with in-memory LRU cho hot queries. 80% benefit, 30% complexity. Upgrade khi evidence shows memory caching insufficient.

### Example 2: 12 Microservices (Balanced Mode)

**Recommendation**: "Split monolith into 12 microservices"

**Necessity**: 3/10 — Monolith works, no bottlenecks, speculative scaling
**Complexity**: 9/10 — Service mesh, distributed tracing, 12 deploys, 2-person team
**Ratio**: 3.0

**Result**: ❌ Skip — Premature optimization. Keep monolith, use modules for boundaries. Trigger: deploy time >30min hoặc actual scaling bottlenecks measured.

### Example 3: SQL Injection Fix (Any Mode)

**Recommendation**: "Fix SQL injection in login endpoint"

**Necessity**: 10/10 — Critical security vulnerability
**Complexity**: 2/10 — Use parameterized queries (standard practice)
**Ratio**: 0.2

**Result**: ✅ Implement now — No debate.

---

## Exemptions từ Pragmatic Analysis

Các recommendation này KHÔNG bị challenge bởi pragmatic mode:

1. **Security vulnerabilities** — critical fixes luôn implement
2. **Compliance requirements** — legal/regulatory non-negotiable
3. **Accessibility issues** — user accessibility không optional
4. **Data loss risks** — anything preventing data loss là critical
5. **Explicit user request** — nếu user đã specify, honor it

```yaml
pragmatic_mode:
  exemptions:
    - security
    - compliance
    - accessibility
    - data_loss_prevention
```

---

## Trong Collaborative Discussion

Pragmatic Enforcer trong discussion nên:
1. **Challenge complexity** — question whether proposed solutions are minimal
2. **Require evidence** — ask for concrete evidence, not speculation
3. **Propose simplifications** — suggest simpler alternatives
4. **Balance views** — acknowledge khi complexity IS justified
5. **Set priorities** — focus team on high-impact, low-complexity wins

```markdown
**Security Specialist**: "Cần implement zero-trust architecture across all services."

**Pragmatic Enforcer**: "Security value rõ ràng, nhưng đó là significant complexity.
Current threat là gì? Start với auth boundaries trên public APIs trước được không?"

**Security Specialist**: "Fair point. Internal services chưa bị target. API gateway auth
address được 90% current risk."

**Systems Architect**: "Agreed — zero-trust là roadmap item khi có evidence cần thiết."
```
