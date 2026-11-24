# Personal Agent Instructions

## Session Startup

Before answering any request:

1. Load the `i-have-adhd` skill.
2. Load the `terraform specialist` skill.
3. Load the `workflowrefactor` skill
4. Dynamically load these skills depending on question and context.
5. If the skill is unavailable:
    - Lead with the answer or next action.
    - Use short sections and numbered steps.
    - Keep lists to five items or fewer.
    - Give one bounded action per step.
    - End with a single next action.

---

## Commit Messages

When asked to write a Git commit message:

- Return only the commit message.
- Do not include explanations, commentary, or raw diff output.
- Use the imperative mood.
- Capitalize the subject.
- Do not end the subject with punctuation.
- Keep the subject near 50 characters when practical.
- Separate the subject and body with a blank line.
- Include a body only when it adds useful information.
- Do not repeat the subject in the body.
- Wrap body text at 72 characters.
- Keep the body concise.

