/**
 * Session State Type Definitions
 * Part of Phase 1.0: Automation Infrastructure
 * See: .docs/SESSION-STATE.md for schema details
 */

/**
 * Complete session state structure
 */
export interface SessionState {
  schema_version: string;
  project: ProjectInfo;
  current: CurrentState;
  timing: TimingInfo;
  checkpoint: CheckpointInfo;
  progress: ProgressInfo;
  git_state: GitState;
  metadata: MetadataInfo;
}

/**
 * Project information
 */
export interface ProjectInfo {
  name: string;
  version: string;
  remote_url: string;
}

/**
 * Current working context
 */
export interface CurrentState {
  phase: string;
  phase_name: string;
  task: string;
  task_name: string;
  working_branch: string;
  base_branch: string;
}

/**
 * Timing information
 */
export interface TimingInfo {
  phase_start: string;
  task_start: string;
  last_activity: string;
  last_sync: string;
}

/**
 * Checkpoint information
 */
export interface CheckpointInfo {
  tag: string;
  commit: string;
  timestamp: string;
  message: string;
}

/**
 * Progress tracking
 */
export interface ProgressInfo {
  tasks_completed: string[];
  tasks_total: number;
  completion_percentage: number;
}

/**
 * Git repository state
 */
export interface GitState {
  local_commits_ahead: number;
  remote_commits_ahead: number;
  modified_files: number;
  untracked_files: number;
  staged_files: number;
  working_directory_clean: boolean;
}

/**
 * Metadata for state file
 */
export interface MetadataInfo {
  last_updated_by: string;
  last_updated_at: string;
}

/**
 * Progress tracking file structure
 */
export interface ProgressData {
  schema_version: string;
  project: {
    name: string;
    version: string;
  };
  phases: PhaseProgress[];
  summary: {
    total_phases: number;
    completed_phases: number;
    current_phase: string;
    overall_completion: number;
  };
}

/**
 * Phase progress tracking
 */
export interface PhaseProgress {
  phase: string;
  phase_name: string;
  status: 'not_started' | 'in_progress' | 'completed';
  start_date: string;
  end_date?: string;
  tasks: TaskProgress[];
  completion_percentage: number;
}

/**
 * Task progress tracking
 */
export interface TaskProgress {
  task_id: string;
  task_name: string;
  status: 'not_started' | 'in_progress' | 'completed' | 'blocked';
  start_date?: string;
  end_date?: string;
  checkpoint_tag?: string;
  notes?: string;
}

/**
 * Checkpoints history file structure
 */
export interface CheckpointsData {
  schema_version: string;
  project: {
    name: string;
    version: string;
  };
  checkpoints: CheckpointEntry[];
}

/**
 * Single checkpoint entry
 */
export interface CheckpointEntry {
  tag: string;
  commit: string;
  timestamp: string;
  type: 'task' | 'phase' | 'manual';
  phase: string;
  task?: string;
  message: string;
  git_state: {
    branch: string;
    files_changed: number;
    insertions: number;
    deletions: number;
  };
}

/**
 * State update operation
 */
export interface StateUpdate {
  path: string;
  value: any;
}

/**
 * State validation result
 */
export interface ValidationResult {
  valid: boolean;
  errors: string[];
  warnings: string[];
}

/**
 * State snapshot for recovery
 */
export interface StateSnapshot {
  timestamp: string;
  session_state: SessionState;
  progress: ProgressData;
  checkpoints: CheckpointsData;
}
