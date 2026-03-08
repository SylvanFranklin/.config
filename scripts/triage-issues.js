const Anthropic = require('@anthropic-ai/sdk');
const { Octokit } = require('@octokit/rest');

const anthropic = new Anthropic.default({ apiKey: process.env.ANTHROPIC_API_KEY });
const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });
const [owner, repo] = process.env.GITHUB_REPOSITORY.split('/');

// Invisible tag so we know this issue has already been triaged
const BOT_TAG = '<!-- triage-bot -->';

const SYSTEM_PROMPT = `You are triaging GitHub issues for a content creator's project.

An issue is USEFUL if it:
- Is about configuration (setup, settings, options, integrations)
- Has a clear, specific ask or bug report
- Includes enough context to actually act on
- Includes reproduction steps if it's a bug

An issue is NOT USEFUL if it:
- Asks for a portfolio, website, or content review
- Is vague with no clear ask
- Lacks context or reproduction steps for bugs
- Is off-topic (not about configuration)

Respond ONLY with raw JSON, no markdown, no explanation:
{
  "useful": true or false,
  "reason": "one sentence, max 15 words, blunt and direct"
}

The reason will be posted publicly as a GitHub comment. Write like a person, not a bot.
No "Unfortunately", no "I notice that", no "It seems like". Just say what the problem is.
Examples of good reasons:
- "This is asking for a website review, not a config issue."
- "No reproduction steps — can't debug without them."
- "Not enough context to know what you're trying to configure."`;

async function getOpenIssues() {
  return octokit.paginate(octokit.rest.issues.listForRepo, {
    owner,
    repo,
    state: 'open',
    per_page: 100,
  });
}

async function botAlreadyCommented(issueNumber) {
  const { data: comments } = await octokit.rest.issues.listComments({
    owner,
    repo,
    issue_number: issueNumber,
  });
  return comments.some((c) => c.body.includes(BOT_TAG));
}

async function evaluateIssue(issue) {
  const content = `Title: ${issue.title}\n\nBody:\n${issue.body?.trim() || '(empty)'}`;

  const response = await anthropic.messages.create({
    model: 'claude-sonnet-4-20250514',
    max_tokens: 200,
    system: SYSTEM_PROMPT,
    messages: [{ role: 'user', content }],
  });

  const text = response.content[0].text.trim();
  return JSON.parse(text);
}

async function postComment(issueNumber, reason) {
  await octokit.rest.issues.createComment({
    owner,
    repo,
    issue_number: issueNumber,
    body: `${reason}\n\n${BOT_TAG}`,
  });
  console.log(`  → Commented on #${issueNumber}`);
}

async function main() {
  const allIssues = await getOpenIssues();
  // Filter out pull requests
  const issues = allIssues.filter((i) => !i.pull_request);

  console.log(`Checking ${issues.length} open issues...`);

  for (const issue of issues) {
    process.stdout.write(`#${issue.number} "${issue.title}" — `);

    const alreadyDone = await botAlreadyCommented(issue.number);
    if (alreadyDone) {
      console.log('skipped (already triaged)');
      continue;
    }

    try {
      const result = await evaluateIssue(issue);

      if (result.useful) {
        console.log('✓ useful');
      } else {
        console.log(`✗ not useful: ${result.reason}`);
        await postComment(issue.number, result.reason);
      }
    } catch (err) {
      console.error(`error: ${err.message}`);
    }

    // Be polite to the APIs
    await new Promise((r) => setTimeout(r, 500));
  }

  console.log('Done.');
}

main();
