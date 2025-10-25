#!/usr/bin/env node

/**
 * Git Status Monitoring System
 *
 * Tracks tool usage and displays git status every ~5 tool uses
 * Integrates with Claude Code via MCP server pattern
 *
 * This module provides:
 * - Tool use tracking
 * - Periodic git status display
 * - Session state integration
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const STATE_FILE = path.join(__dirname, '..', '.claude', 'monitor-state.json');
const TOOL_USE_THRESHOLD = 5;

/**
 * Initialize or load monitor state
 */
function loadState() {
  try {
    if (fs.existsSync(STATE_FILE)) {
      return JSON.parse(fs.readFileSync(STATE_FILE, 'utf8'));
    }
  } catch (err) {
    console.error('⚠ Could not load monitor state:', err.message);
  }

  return {
    toolUseCount: 0,
    lastStatusCheck: null,
    lastToolUse: null,
  };
}

/**
 * Save monitor state
 */
function saveState(state) {
  try {
    const dir = path.dirname(STATE_FILE);
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    fs.writeFileSync(STATE_FILE, JSON.stringify(state, null, 2));
  } catch (err) {
    console.error('⚠ Could not save monitor state:', err.message);
  }
}

/**
 * Get git status in concise format
 */
function getGitStatus() {
  try {
    const status = execSync('git status --short --branch', {
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe'],
    });

    const ahead = execSync('git rev-list --count @{upstream}..HEAD 2>/dev/null || echo 0', {
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe'],
    }).trim();

    const behind = execSync('git rev-list --count HEAD..@{upstream} 2>/dev/null || echo 0', {
      encoding: 'utf8',
      stdio: ['pipe', 'pipe', 'pipe'],
    }).trim();

    return {
      status: status.trim(),
      ahead: parseInt(ahead),
      behind: parseInt(behind),
    };
  } catch (err) {
    return {
      status: 'Could not retrieve git status',
      ahead: 0,
      behind: 0,
      error: err.message,
    };
  }
}

/**
 * Display git status banner
 */
function displayGitStatus() {
  const gitStatus = getGitStatus();

  console.log('\n' + '='.repeat(60));
  console.log('📊 GIT STATUS MONITOR');
  console.log('='.repeat(60));

  if (gitStatus.error) {
    console.log('⚠️  Error:', gitStatus.error);
  } else {
    console.log(gitStatus.status);

    if (gitStatus.ahead > 0) {
      console.log(`\n⬆️  ${gitStatus.ahead} commit(s) ahead of remote - Consider pushing`);
    }

    if (gitStatus.behind > 0) {
      console.log(`\n⬇️  ${gitStatus.behind} commit(s) behind remote - Consider pulling`);
    }

    // Check for uncommitted changes
    const lines = gitStatus.status.split('\n').slice(1); // Skip branch line
    const modifiedFiles = lines.filter((l) => l.startsWith(' M')).length;
    const untrackedFiles = lines.filter((l) => l.startsWith('??')).length;
    const stagedFiles = lines.filter((l) => l.startsWith('M ') || l.startsWith('A ')).length;

    if (modifiedFiles + untrackedFiles + stagedFiles > 0) {
      console.log('\n📝 Uncommitted changes detected:');
      if (stagedFiles > 0) console.log(`   - ${stagedFiles} file(s) staged for commit`);
      if (modifiedFiles > 0) console.log(`   - ${modifiedFiles} file(s) modified but not staged`);
      if (untrackedFiles > 0) console.log(`   - ${untrackedFiles} untracked file(s)`);
      console.log('\n💡 Consider using /commit to create a checkpoint');
    }
  }

  console.log('='.repeat(60) + '\n');
}

/**
 * Record tool use and check if status display needed
 */
function recordToolUse() {
  const state = loadState();

  state.toolUseCount = (state.toolUseCount || 0) + 1;
  state.lastToolUse = new Date().toISOString();

  // Check if we should display git status
  if (state.toolUseCount >= TOOL_USE_THRESHOLD) {
    displayGitStatus();
    state.toolUseCount = 0;
    state.lastStatusCheck = new Date().toISOString();
  }

  saveState(state);

  return state.toolUseCount;
}

/**
 * Reset tool use counter (called after manual status check)
 */
function resetCounter() {
  const state = loadState();
  state.toolUseCount = 0;
  state.lastStatusCheck = new Date().toISOString();
  saveState(state);
}

/**
 * Manual status check (bypasses counter)
 */
function checkStatus() {
  displayGitStatus();
  resetCounter();
}

// CLI interface
if (require.main === module) {
  const command = process.argv[2];

  switch (command) {
    case 'record':
      const count = recordToolUse();
      console.log(`Tool use recorded (${count}/${TOOL_USE_THRESHOLD})`);
      break;

    case 'check':
      checkStatus();
      break;

    case 'reset':
      resetCounter();
      console.log('Counter reset');
      break;

    case 'state':
      console.log(JSON.stringify(loadState(), null, 2));
      break;

    default:
      console.log(`
Git Status Monitor

Usage:
  node monitor-git-status.js record   # Record tool use, display if threshold reached
  node monitor-git-status.js check    # Manually check git status
  node monitor-git-status.js reset    # Reset tool use counter
  node monitor-git-status.js state    # Display current state
      `);
      process.exit(1);
  }
}

module.exports = {
  recordToolUse,
  checkStatus,
  resetCounter,
  loadState,
  getGitStatus,
};
