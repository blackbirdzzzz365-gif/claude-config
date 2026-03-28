# Architecture Review: [Target]

**Date**: [YYYY-MM-DD]
**Review Type**: Version | Feature | Component
**Reviewers**: [List all members]

---

## Executive Summary

[2-3 paragraphs: overall architecture state, key findings, critical actions. Readable by non-technical stakeholders.]

**Overall Assessment**: Strong | Adequate | Needs Improvement

**Key Findings**:
- [Finding 1 — most significant]
- [Finding 2]
- [Finding 3]

**Critical Actions**:
- [Action 1 — most urgent]
- [Action 2]

---

## System Overview

[Version/feature/component được review, scope, tech stack, architecture style, team size, constraints]

---

## Individual Member Reviews

[Dùng format từ references/review-process.md cho mỗi member]

### [Member Name] — [Title]

**Perspective**: [Their unique viewpoint]

#### Key Observations
- [Observation 1]

#### Strengths
1. **[Strength]**: [Description]

#### Concerns
1. **[Concern]** (Impact: High/Medium/Low)
   - **Issue**: [What's wrong]
   - **Why it matters**: [Impact]
   - **Recommendation**: [What to do]

#### Recommendations
1. **[Recommendation]** (Priority: H/M/L, Effort: S/M/L)
   - **What**: [Action]
   - **Why**: [Benefit]
   - **How**: [Approach]

[Nếu pragmatic mode enabled, thêm Pragmatic Enforcer Analysis — xem references/pragmatic-integration.md]

[Lặp lại cho mỗi member]

---

## Collaborative Discussion

**[Systems Architect]**: "[Opening statement]"

**[Domain Expert]**: "[Complementary view]"

[Continue discussion flow]

### Common Ground

Team agrees on:
1. [Consensus point 1]
2. [Consensus point 2]

### Areas of Debate

**Topic: [Topic]**
- **[Member 1]**: [Position]
- **[Member 2]**: [Position]
- **Resolution**: [How reconciled]

### Priorities Established

**Critical (0-2 weeks)**:
1. [Critical priority]

**Important (2-8 weeks)**:
1. [Important priority]

**Nice-to-Have (2-6 months)**:
1. [Nice-to-have]

---

## Consolidated Findings

### Strengths

1. **[Strength]**: [What's working well, why valuable, how to sustain]
2. **[Strength]**: [Description]
[4-7 strengths]

### Areas for Improvement

1. **[Area]**:
   - **Current state**: [What exists now]
   - **Desired state**: [What it should be]
   - **Gap**: [What's missing]
   - **Priority**: High | Medium | Low

[5-10 areas depending on scope]

### Technical Debt

**High Priority**:
- **[Debt Item]**:
  - **Impact**: [How it affects dev/ops]
  - **Resolution**: [What needs done]
  - **Effort**: S | M | L
  - **Timeline**: [When to address]

**Medium Priority**:
- **[Debt Item]**: [Details]

**Low Priority**:
- **[Debt Item]**: [Details]

### Risks

**Technical Risks**:
- **[Risk]** (Likelihood: H/M/L, Impact: H/M/L)
  - **Description**: [What could go wrong]
  - **Mitigation**: [How to reduce]

**Business Risks**:
- **[Risk]**: [Details]

---

## Recommendations

### Immediate (0-2 weeks)

1. **[Action]**
   - **Why**: [Problem solved / value created]
   - **How**: [Implementation approach]
   - **Owner**: [Team/person]
   - **Success Criteria**: [How to know it's done]
   - **Effort**: [Estimate]

### Short-term (2-8 weeks)

1. **[Action]**: [Details]

### Long-term (2-6 months)

1. **[Action]**: [Details]

---

## Success Metrics

| Metric | Current | Target | Timeline |
|--------|---------|--------|----------|
| [e.g., Test Coverage] | [45%] | [75%] | [3 months] |
| [e.g., P95 Response] | [500ms] | [200ms] | [2 months] |

---

## Follow-up

**Next Review**: [Specific date or milestone]

**Tracking**:
- Create GitHub issues for immediate actions
- Add to sprint backlog
- Recalibration: "Start architecture recalibration for [target]"

**Accountability**:
- [Who tracks implementation]
- [Check frequency]
- [Where status updates go]

---

## Related Documentation

**ADRs**:
- [ADR-XXX: Title](../decisions/adrs/ADR-XXX-title.md) — [Relationship to review]

**Previous Reviews**:
- [Previous review] — [Date] — [How architecture evolved]

---

## Appendix

### Review Methodology

Conducted using AI Software Architect framework.

**Members:**
- Systems Architect — Overall coherence
- Domain Expert — Business domain
- Security Specialist — Security analysis
- Performance Specialist — Scalability
- Maintainability Expert — Tech debt
[Additional members as applicable]

[If pragmatic mode enabled:]
**Pragmatic Mode**: [Strict | Balanced | Lenient] (ratio target: [<1.0 | <1.5 | <2.0])

---

**Review Complete**
