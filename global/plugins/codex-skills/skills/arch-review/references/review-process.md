# Architecture Review Process — Chi tiết

## Individual Member Review Format

Mỗi member trong `.architecture/members.yml` review từ unique perspective của họ.

```markdown
### [Member Name] — [Title]

**Perspective**: [Their viewpoint from members.yml]

#### Key Observations
- [Specific finding 1 — concrete, not vague]
- [Specific finding 2]
- [Continue 3-5 observations]

#### Strengths
1. **[Strength Title]**: [Why it's working well and why it matters]
2. **[Strength Title]**: [Description]
[Aim for 3-5 strengths]

#### Concerns
1. **[Concern Title]** (Impact: High | Medium | Low)
   - **Issue**: [Clear description of the problem]
   - **Why it matters**: [Impact on system/users/development]
   - **Recommendation**: [Specific actionable fix]

2. **[Concern Title]** (Impact: High | Medium | Low)
   - **Issue**: [Description]
   - **Why it matters**: [Impact]
   - **Recommendation**: [Action]
[Aim for 3-7 concerns, prioritized by impact]

#### Recommendations
1. **[Recommendation Title]** (Priority: High/Medium/Low, Effort: S/M/L)
   - **What**: [What to do]
   - **Why**: [Benefit or risk addressed]
   - **How**: [Brief implementation approach]
[Aim for 3-7 recommendations]
```

### Member-Specific Guidance

**Systems Architect:**
- Overall system coherence, architectural patterns
- Component interactions và integration points
- Alignment với architectural principles
- Long-term evolvability

**Domain Expert:**
- Business domain representation
- Bounded contexts và domain model accuracy
- Ubiquitous language usage
- Semantic correctness

**Security Specialist:**
- Authentication, authorization, encryption
- Data protection và privacy
- Security boundaries và attack surface
- OWASP vulnerabilities

**Performance Specialist:**
- Performance bottlenecks
- Scalability patterns
- Caching, optimization opportunities
- Resource utilization

**Maintainability Expert:**
- Code organization và clarity
- Technical debt
- Complexity và coupling
- Developer experience

**AI Engineer (nếu applicable):**
- LLM integration patterns
- Agent orchestration
- Prompt engineering quality
- Evaluation và observability

---

## Collaborative Discussion Process

Sau individual reviews, simulate discussion giữa các members.

```markdown
## Collaborative Discussion

**[Systems Architect]**: "[Opening về overall architecture]"

**[Domain Expert]**: "[Complementary view từ domain perspective]"

**[Security Specialist]**: "[Security concerns hoặc validation]"

[Continue flow tự nhiên — members reference và build on nhau's findings]

### Common Ground

Team agrees on:
1. [Consensus point 1]
2. [Consensus point 2]

### Areas of Debate

**Topic: [Topic]**
- **[Member 1]**: [Their position]
- **[Member 2]**: [Their position]
- **Resolution**: [Consensus hoặc agree-to-disagree với justification]

### Priorities Established

**Critical (Address Immediately — 0-2 weeks)**:
1. [Critical priority]

**Important (Address Soon — 2-8 weeks)**:
1. [Important priority]

**Nice-to-Have (2-6 months)**:
1. [Nice-to-have]
```

### Discussion Best Practices

1. **Cross-Reference**: Members reference và build on nhau's findings
2. **Resolve Conflicts**: Discuss trade-offs, reach consensus
3. **Prioritize Together**: Rank recommendations theo urgency và impact
4. **Be Realistic**: Consider project constraints, deadlines, team capacity
5. **Stay Constructive**: Frame concerns as improvement opportunities

---

## Analysis Guidelines by Review Type

### Version Reviews

**Focus on:**
- Overall architectural health tại milestone này
- Components và interactions
- Patterns và consistency
- Technical debt accumulated
- ADRs implemented hoặc needed
- Alignment với original architecture vision

**Key Questions:**
- Architecture còn coherent không khi system evolve?
- Technical debt nào cần address trước next version?
- Architectural principles có được follow không?
- Risks nào cần mitigate?

### Feature Reviews

**Focus on:**
- Feature implementation approach
- Integration với existing architecture
- Data flow và state management
- Security implications
- Performance impact
- Test coverage

**Key Questions:**
- Feature này có fit existing architecture không?
- Có architectural approach nào tốt hơn không?
- Integration risks là gì?
- Ảnh hưởng tới scalability như thế nào?

### Component Reviews

**Focus on:**
- Component architecture và structure
- Dependencies và coupling
- Boundaries và interfaces
- Responsibilities và cohesion
- Testability

**Key Questions:**
- Component có well-designed và focused không?
- Boundaries có clear và appropriate không?
- Có properly decoupled không?
- Single responsibility principle được follow không?

---

## Tips for High-Quality Reviews

### Cụ thể, không mơ hồ

❌ "The code is messy"
✅ "UserService có 15 methods mixing authentication, authorization, và profile management — violates single responsibility"

### Provide Context

❌ "Add caching"
✅ "Add Redis caching cho user profile queries — currently hitting DB 50+ times per page load causing 200ms delays"

### Suggest Solutions

❌ "Performance is bad"
✅ "Batch database queries trong OrderProcessor.process() để giảm N+1 queries — should improve processing time by 70%"

### Balance Positive và Negative

- Đừng chỉ liệt kê problems
- Nhận ra điều đang hoạt động tốt
- Explain tại sao good patterns nên được duy trì

### Actionable

- Mỗi concern phải có recommendation
- Recommendations phải concrete và implementable
- Estimate effort (S/M/L) và priority (H/M/L)
