/**
 * Session State Management - Main Entry Point
 * Part of Phase 1.0: Automation Infrastructure
 * See: .docs/SESSION-STATE.md for complete documentation
 */

// Export all types
export * from './types';

// Export reader functions
export {
  readSessionState,
  sessionStateExists,
  readCurrentState,
  readTimingInfo,
  readCheckpointInfo,
  readProgressInfo,
  readGitState,
  readProgressData,
  progressDataExists,
  readCheckpointsData,
  checkpointsDataExists,
  getCurrentPhase,
  getCurrentTask,
  getCurrentBranch,
  getCompletedTasks,
  isTaskCompleted,
  getLastCheckpoint,
  getTimeSinceLastActivity,
  getPhaseDuration,
  getTaskDuration,
  isWorkingDirectoryClean,
  getUncommittedChanges,
  safeReadSessionState,
  safeReadProgressData,
  safeReadCheckpointsData,
} from './reader';

// Export writer functions
export {
  writeSessionState,
  updateSessionState,
  updateStateField,
  updateCurrentState,
  updateTimingInfo,
  updateLastActivity,
  updateLastSync,
  updateCheckpoint,
  addCompletedTask,
  updateGitState,
  updateMetadata,
  writeProgressData,
  writeCheckpointsData,
  addCheckpointEntry,
  batchUpdateSessionState,
  backupSessionState,
  restoreSessionState,
} from './writer';

// Export validator functions
export {
  validateSessionState,
  validateProgressData,
  validateCheckpointsData,
  validateStateConsistency,
  isStateSafe,
  getValidationSummary,
} from './validator';
