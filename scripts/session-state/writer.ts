/**
 * Session State Writer Functions
 * Part of Phase 1.0: Automation Infrastructure
 * See: .docs/SESSION-STATE.md for usage details
 */

import * as fs from 'fs';
import * as path from 'path';
import {
  SessionState,
  ProgressData,
  CheckpointsData,
  CheckpointEntry,
  StateUpdate,
} from './types';
import { readSessionState, readProgressData, readCheckpointsData } from './reader';

/**
 * Default paths for state files
 */
const PROJECT_ROOT = path.resolve(__dirname, '../..');
const SESSION_STATE_FILE = path.join(PROJECT_ROOT, '.claude/session-state.json');
const PROGRESS_FILE = path.join(PROJECT_ROOT, '.claude/progress.json');
const CHECKPOINTS_FILE = path.join(PROJECT_ROOT, '.claude/checkpoints.json');

/**
 * Write complete session state
 */
export function writeSessionState(
  state: SessionState,
  filePath: string = SESSION_STATE_FILE
): void {
  try {
    const json = JSON.stringify(state, null, 2);
    fs.writeFileSync(filePath, json + '\n', 'utf-8');
  } catch (error) {
    throw new Error(`Failed to write session state: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Update session state fields
 */
export function updateSessionState(
  updates: Partial<SessionState>,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);
  const updatedState = { ...state, ...updates };

  // Update metadata
  updatedState.metadata.last_updated_at = new Date().toISOString();

  writeSessionState(updatedState, filePath);
}

/**
 * Update nested field in session state
 */
export function updateStateField(
  path: string,
  value: any,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);
  const keys = path.split('.');

  let current: any = state;
  for (let i = 0; i < keys.length - 1; i++) {
    current = current[keys[i]];
  }
  current[keys[keys.length - 1]] = value;

  // Update metadata
  state.metadata.last_updated_at = new Date().toISOString();

  writeSessionState(state, filePath);
}

/**
 * Update current working context
 */
export function updateCurrentState(
  updates: Partial<SessionState['current']>,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);
  state.current = { ...state.current, ...updates };
  state.metadata.last_updated_at = new Date().toISOString();
  writeSessionState(state, filePath);
}

/**
 * Update timing information
 */
export function updateTimingInfo(
  updates: Partial<SessionState['timing']>,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);
  state.timing = { ...state.timing, ...updates };
  state.metadata.last_updated_at = new Date().toISOString();
  writeSessionState(state, filePath);
}

/**
 * Update last activity timestamp
 */
export function updateLastActivity(filePath: string = SESSION_STATE_FILE): void {
  const timestamp = new Date().toISOString();
  updateStateField('timing.last_activity', timestamp, filePath);
}

/**
 * Update last sync timestamp
 */
export function updateLastSync(filePath: string = SESSION_STATE_FILE): void {
  const timestamp = new Date().toISOString();
  updateStateField('timing.last_sync', timestamp, filePath);
}

/**
 * Update checkpoint information
 */
export function updateCheckpoint(
  tag: string,
  commit: string,
  message: string,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);
  const timestamp = new Date().toISOString();

  state.checkpoint = {
    tag,
    commit,
    timestamp,
    message,
  };

  state.metadata.last_updated_at = timestamp;
  writeSessionState(state, filePath);
}

/**
 * Add completed task
 */
export function addCompletedTask(
  taskId: string,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);

  if (!state.progress.tasks_completed.includes(taskId)) {
    state.progress.tasks_completed.push(taskId);

    // Update completion percentage if total is known
    if (state.progress.tasks_total > 0) {
      state.progress.completion_percentage = Math.round(
        (state.progress.tasks_completed.length / state.progress.tasks_total) * 100
      );
    }
  }

  state.metadata.last_updated_at = new Date().toISOString();
  writeSessionState(state, filePath);
}

/**
 * Update git state
 */
export function updateGitState(
  updates: Partial<SessionState['git_state']>,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);
  state.git_state = { ...state.git_state, ...updates };
  state.metadata.last_updated_at = new Date().toISOString();
  writeSessionState(state, filePath);
}

/**
 * Update metadata updater info
 */
export function updateMetadata(
  updatedBy: string,
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);
  state.metadata.last_updated_by = updatedBy;
  state.metadata.last_updated_at = new Date().toISOString();
  writeSessionState(state, filePath);
}

/**
 * Write progress data
 */
export function writeProgressData(
  data: ProgressData,
  filePath: string = PROGRESS_FILE
): void {
  try {
    const json = JSON.stringify(data, null, 2);
    fs.writeFileSync(filePath, json + '\n', 'utf-8');
  } catch (error) {
    throw new Error(`Failed to write progress data: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Write checkpoints data
 */
export function writeCheckpointsData(
  data: CheckpointsData,
  filePath: string = CHECKPOINTS_FILE
): void {
  try {
    const json = JSON.stringify(data, null, 2);
    fs.writeFileSync(filePath, json + '\n', 'utf-8');
  } catch (error) {
    throw new Error(`Failed to write checkpoints data: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Add checkpoint entry to history
 */
export function addCheckpointEntry(
  entry: CheckpointEntry,
  filePath: string = CHECKPOINTS_FILE
): void {
  let data: CheckpointsData;

  try {
    data = readCheckpointsData(filePath);
  } catch {
    // Initialize if doesn't exist
    data = {
      schema_version: '1.0.0',
      project: {
        name: 'ui-library',
        version: '1.0.0',
      },
      checkpoints: [],
    };
  }

  data.checkpoints.push(entry);
  writeCheckpointsData(data, filePath);
}

/**
 * Batch update multiple fields
 */
export function batchUpdateSessionState(
  updates: StateUpdate[],
  filePath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(filePath);

  for (const update of updates) {
    const keys = update.path.split('.');
    let current: any = state;

    for (let i = 0; i < keys.length - 1; i++) {
      current = current[keys[i]];
    }

    current[keys[keys.length - 1]] = update.value;
  }

  state.metadata.last_updated_at = new Date().toISOString();
  writeSessionState(state, filePath);
}

/**
 * Create backup of session state
 */
export function backupSessionState(filePath: string = SESSION_STATE_FILE): string {
  const state = readSessionState(filePath);
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupPath = filePath.replace('.json', `.backup.${timestamp}.json`);

  writeSessionState(state, backupPath);
  return backupPath;
}

/**
 * Restore session state from backup
 */
export function restoreSessionState(
  backupPath: string,
  targetPath: string = SESSION_STATE_FILE
): void {
  const state = readSessionState(backupPath);
  writeSessionState(state, targetPath);
}
