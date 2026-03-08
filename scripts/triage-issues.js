const Anthropic = require('@anthropic-ai/sdk');
const { Octokit } = require('@octokit/rest');

const anthropic = new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
const octokit = new Octokit({ auth: process.env.GITHUB_TOKEN });
const [owner, repo] = process.env.GITHUB_REPOSITORY.split('/');

// Invisible tag so we know this issue has already been triaged
const BOT_TAG = '<!-- triage-bot -->';

const SYSTEM_PROMPT = `You are triaging GitHub issues for a content creator's project.

You only care about one thing: is this issue asking for a portfolio review, website review, or career advice?

Respond ONLY with raw JSON. No markdown fences, no explanation, no extra text — just the JSON object:
{"close": true} or {"close": false}

Set close to true ONLY if the issue is clearly asking for:
- A portfolio review
- A website review
- Career advice (e.g. "how do I get started", "review my work", "am I good enough")

Everything else — config questions, bug reports, off-topic stuff, philosophy, whatever — set close to false.`;

const SNARKY_COMMENTS = [
	"NAHH son, I ain't reviewing that shi 💀",
];

function randomSnarky() {
	return SNARKY_COMMENTS[Math.floor(Math.random() * SNARKY_COMMENTS.length)];
}

async function getOpenIssues() {
	return octokit.paginate(octokit.rest.issues.listForRepo, {
		owner,
		repo,
		state: 'open',
		per_page: 100,
	});
}

async function botAlreadyTriaged(issueNumber) {
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

	const raw = response.content[0].text.trim();
	const clean = raw.replace(/^```(?:json)?\s*/i, '').replace(/\s*```$/, '');
	return JSON.parse(clean);
}

async function closeIssue(issueNumber) {
	const comment = randomSnarky();
	await octokit.rest.issues.createComment({
		owner,
		repo,
		issue_number: issueNumber,
		body: `${comment}\n\n${BOT_TAG}`,
	});
	await octokit.rest.issues.update({
		owner,
		repo,
		issue_number: issueNumber,
		state: 'closed',
		state_reason: 'not_planned',
	});
	console.log(`  → Closed #${issueNumber}: "${comment}"`);
}

async function main() {
	const allIssues = await getOpenIssues();
	const issues = allIssues.filter((i) => !i.pull_request);

	console.log(`Checking ${issues.length} open issues...`);

	for (const issue of issues) {
		process.stdout.write(`#${issue.number} "${issue.title}" — `);

		const alreadyDone = await botAlreadyTriaged(issue.number);
		if (alreadyDone) {
			console.log('skipped (already triaged)');
			continue;
		}

		try {
			const result = await evaluateIssue(issue);

			if (result.close) {
				await closeIssue(issue.number);
			} else {
				console.log('✓ keeping open');
			}
		} catch (err) {
			console.error(`error: ${err.message}`);
		}

		await new Promise((r) => setTimeout(r, 500));
	}

	console.log('Done.');
}

main();
