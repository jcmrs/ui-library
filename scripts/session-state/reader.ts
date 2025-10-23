/**
 * Session State Reader Functions
 * Part of Phase 1.0: Automation Infrastructure
 * See: .docs/SESSION-STATE.md for usage details
 */

import * as fs from 'fs';
import * as path from 'path';
import {
  SessionState,
  ProgressData,
  CheckpointsData,
  CurrentState,
  TimingInfo,
  CheckpointInfo,
  ProgressInfo,
  GitState,
} from './types';

/**
 * Default paths for state files
 */
const PROJECT_ROOT = path.resolve(__dirname, '../..');
const SESSION_STATE_FILE = path.join(PROJECT_ROOT, '.claude/session-state.json');
const PROGRESS_FILE = path.join(PROJECT_ROOT, '.claude/progress.json');
const CHECKPOINTS_FILE = path.join(PROJECT_ROOT, '.claude/checkpoints.json');

/**
 * Read complete session state
 */
export function readSessionState(filePath: string = SESSION_STATE_FILE): SessionState {
  try {
    const content = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(content) as SessionState;
  } catch (error) {
    throw new Error(`Failed to read session state: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Check if session state exists
 */
export function sessionStateExists(filePath: string = SESSION_STATE_FILE): boolean {
  return fs.existsSync(filePath);
}

/**
 * Read current working context
 */
export function readCurrentState(filePath: string = SESSION_STATE_FILE): CurrentState {
  const state = readSessionState(filePath);
  return state.current;
}

/**
 * Read timing information
 */
export function readTimingInfo(filePath: string = SESSION_STATE_FILE): TimingInfo {
  const state = readSessionState(filePath);
  return state.timing;
}

/**
 * Read checkpoint information
 */
export function readCheckpointInfo(filePath: string = SESSION_STATE_FILE): CheckpointInfo {
  const state = readSessionState(filePath);
  return state.checkpoint;
}

/**
 * Read progress information
 */
export function readProgressInfo(filePath: string = SESSION_STATE_FILE): ProgressInfo {
  const state = readSessionState(filePath);
  return state.progress;
}

/**
 * Read git state
 */
export function readGitState(filePath: string = SESSION_STATE_FILE): GitState {
  const state = readSessionState(filePath);
  return state.git_state;
}

/**
 * Read progress data
 */
export function readProgressData(filePath: string = PROGRESS_FILE): ProgressData {
  try {
    const content = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(content) as ProgressData;
  } catch (error) {
    throw new Error(`Failed to read progress data: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Check if progress data exists
 */
export function progressDataExists(filePath: string = PROGRESS_FILE): boolean {
  return fs.existsSync(filePath);
}

/**
 * Read checkpoints data
 */
export function readCheckpointsData(filePath: string = CHECKPOINTS_FILE): CheckpointsData {
  try {
    const content = fs.readFileSync(filePath, 'utf-8');
    return JSON.parse(content) as CheckpointsData;
  } catch (error) {
    throw new Error(`Failed to read checkpoints data: ${error instanceof Error ? error.message : String(error)}`);
  }
}

/**
 * Check if checkpoints data exists
 */
export function checkpointsDataExists(filePath: string = CHECKPOINTS_FILE): boolean {
  return fs.existsSync(filePath);
}

/**
 * Get current phase
 */
export function getCurrentPhase(filePath: string = SESSION_STATE_FILE): string {
  const current = readCurrentState(filePath);
  return current.phase;
}

/**
 * Get current task
 */
export function getCurrentTask(filePath: string = SESSION_STATE_FILE): string {
  const current = readCurrentState(filePath);
  return current.task;
}

/**
 * Get current working branch
 */
export function getCurrentBranch(filePath: string = SESSION_STATE_FILE): string {
  const current = readCurrentState(filePath);
  return current.working_branch;
}

/**
 * Get completed tasks list
 */
export function getCompletedTasks(filePath: string = SESSION_STATE_FILE): string[] {
  const progress = readProgressInfo(filePath);
  return progress.tasks_completed;
}

/**
 * Check if task is completed
 */
export function isTaskCompleted(taskId: string, filePath: string = SESSION_STATE_FILE): boolean {
  const completedTasks = getCompletedTasks(filePath);
  return completedTasks.includes(taskId);
}

/**
 * Get last checkpoint tag
 */
export function getLastCheckpoint(filePath: string = SESSION_STATE_FILE): string {
  const checkpoint = readCheckpointInfo(filePath);
  return checkpoint.tag;
}

/**
 * Get time since last activity (in minutes)
 */
export function getTimeSinceLastActivity(filePath: string = SESSION_STATE_FILE): number {
  const timing = readTimingInfo(filePath);
  const lastActivity = new Date(timing.last_activity);
  const now = new Date();
  const diffMs = now.getTime() - lastActivity.getTime();
  return Math.floor(diffMs / (1000 * 60));
}

/**
 * Get phase duration (in hours)
 */
export function getPhaseDuration(filePath: string = SESSION_STATE_FILE): number {
  const timing = readTimingInfo(filePath);
  const phaseStart = new Date(timing.phase_start);
  const now = new Date();
  const diffMs = now.getTime() - phaseStart.getTime();
  return Math.floor(diffMs / (1000 * 60 * 60));
}

/**
 * Get task duration (in minutes)
 */
export function getTaskDuration(filePath: string = SESSION_STATE_FILE): number {
  const timing = readTimingInfo(filePath);
  const taskStart = new Date(timing.task_start);
  const now = new Date();
  const diffMs = now.getTime() - taskStart.getTime();
  return Math.floor(diffMs / (1000 * 60));
}

/**
 * Is working directory clean
 */
export function isWorkingDirectoryClean(filePath: string = SESSION_STATE_FILE): boolean {
  const gitState = readGitState(filePath);
  return gitState.working_directory_clean;
}

/**
 * Get number of uncommitted changes
 */
export function getUncommittedChanges(filePath: string = SESSION_STATE_FILE): number {
  const gitState = readGitState(filePath);
  return gitState.modified_files + gitState.untracked_files + gitState.staged_files;
}

/**
 * Safe read with fallback
 */
export function safeReadSessionState(filePath: string = SESSION_STATE_FILE): SessionState | null {
  try {
    return readSessionState(filePath);
  } catch {
    return null;
  }
}

/**
 * Safe read progress with fallback
 */
export function safeReadProgressData(filePath: string = PROGRESS_FILE): ProgressData | null {
  try {
    return readProgressData(filePath);
  } catch {
    return null;
  }
}

/**
 * Safe read checkpoints with fallback
 */
export function safeReadCheckpointsData(filePath: string = CHECKPOINTS_FILE): CheckpointsData | null {
  try {
    return readCheckpointsData(filePath);
  } catch {
    return null;
  }
}
