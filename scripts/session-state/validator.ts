/**
 * Session State Validation Functions
 * Part of Phase 1.0: Automation Infrastructure
 * See: .docs/SESSION-STATE.md for usage details
 */

import { SessionState, ProgressData, CheckpointsData, ValidationResult } from './types';

/**
 * Validate complete session state
 */
export function validateSessionState(state: SessionState): ValidationResult {
  const errors: string[] = [];
  const warnings: string[] = [];

  // Validate schema version
  if (!state.schema_version) {
    errors.push('Missing schema_version');
  } else if (state.schema_version !== '1.0.0') {
    warnings.push(`Unexpected schema version: ${state.schema_version}`);
  }

  // Validate project info
  if (!state.project) {
    errors.push('Missing project section');
  } else {
    if (!state.project.name) errors.push('Missing project.name');
    if (!state.project.version) errors.push('Missing project.version');
    if (!state.project.remote_url) warnings.push('Missing project.remote_url');
  }

  // Validate current state
  if (!state.current) {
    errors.push('Missing current section');
  } else {
    if (!state.current.phase) errors.push('Missing current.phase');
    if (!state.current.phase_name) errors.push('Missing current.phase_name');
    if (!state.current.task) errors.push('Missing current.task');
    if (!state.current.task_name) errors.push('Missing current.task_name');
    if (!state.current.working_branch) errors.push('Missing current.working_branch');
    if (!state.current.base_branch) errors.push('Missing current.base_branch');

    // Validate branch naming
    if (state.current.working_branch && !state.current.working_branch.startsWith('feature/')) {
      warnings.push('Working branch should start with feature/');
    }
  }

  // Validate timing
  if (!state.timing) {
    errors.push('Missing timing section');
  } else {
    if (!state.timing.phase_start) errors.push('Missing timing.phase_start');
    if (!state.timing.task_start) errors.push('Missing timing.task_start');
    if (!state.timing.last_activity) errors.push('Missing timing.last_activity');
    if (!state.timing.last_sync) warnings.push('Missing timing.last_sync');

    // Validate timestamps are valid ISO 8601
    const timestamps = [
      { name: 'phase_start', value: state.timing.phase_start },
      { name: 'task_start', value: state.timing.task_start },
      { name: 'last_activity', value: state.timing.last_activity },
      { name: 'last_sync', value: state.timing.last_sync },
    ];

    for (const ts of timestamps) {
      if (ts.value && isNaN(Date.parse(ts.value))) {
        errors.push(`Invalid timestamp format for timing.${ts.name}: ${ts.value}`);
      }
    }

    // Validate timestamp order
    if (state.timing.phase_start && state.timing.task_start) {
      const phaseStart = new Date(state.timing.phase_start);
      const taskStart = new Date(state.timing.task_start);
      if (taskStart < phaseStart) {
        errors.push('task_start cannot be before phase_start');
      }
    }
  }

  // Validate checkpoint
  if (!state.checkpoint) {
    warnings.push('Missing checkpoint section');
  } else {
    if (state.checkpoint.tag && !state.checkpoint.commit) {
      errors.push('Checkpoint has tag but missing commit');
    }
    if (state.checkpoint.commit && !state.checkpoint.tag) {
      errors.push('Checkpoint has commit but missing tag');
    }
  }

  // Validate progress
  if (!state.progress) {
    errors.push('Missing progress section');
  } else {
    if (!Array.isArray(state.progress.tasks_completed)) {
      errors.push('progress.tasks_completed must be an array');
    }
    if (typeof state.progress.tasks_total !== 'number') {
      errors.push('progress.tasks_total must be a number');
    }
    if (typeof state.progress.completion_percentage !== 'number') {
      errors.push('progress.completion_percentage must be a number');
    }

    // Validate completion percentage
    if (state.progress.completion_percentage < 0 || state.progress.completion_percentage > 100) {
      errors.push('completion_percentage must be between 0 and 100');
    }

    // Validate consistency
    if (state.progress.tasks_total > 0 && state.progress.tasks_completed) {
      if (state.progress.tasks_completed.length > state.progress.tasks_total) {
        warnings.push('More tasks completed than total tasks');
      }
    }
  }

  // Validate git_state
  if (!state.git_state) {
    warnings.push('Missing git_state section');
  } else {
    const numericFields = [
      'local_commits_ahead',
      'remote_commits_ahead',
      'modified_files',
      'untracked_files',
      'staged_files',
    ];

    for (const field of numericFields) {
      const value = (state.git_state as any)[field];
      if (typeof value !== 'number' || value < 0) {
        errors.push(`git_state.${field} must be a non-negative number`);
      }
    }

    if (typeof state.git_state.working_directory_clean !== 'boolean') {
      errors.push('git_state.working_directory_clean must be a boolean');
    }
  }

  // Validate metadata
  if (!state.metadata) {
    warnings.push('Missing metadata section');
  } else {
    if (!state.metadata.last_updated_by) {
      warnings.push('Missing metadata.last_updated_by');
    }
    if (!state.metadata.last_updated_at) {
      errors.push('Missing metadata.last_updated_at');
    } else if (isNaN(Date.parse(state.metadata.last_updated_at))) {
      errors.push('Invalid timestamp format for metadata.last_updated_at');
    }
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings,
  };
}

/**
 * Validate progress data
 */
export function validateProgressData(data: ProgressData): ValidationResult {
  const errors: string[] = [];
  const warnings: string[] = [];

  if (!data.schema_version) {
    errors.push('Missing schema_version');
  }

  if (!data.project) {
    errors.push('Missing project section');
  }

  if (!Array.isArray(data.phases)) {
    errors.push('phases must be an array');
  } else {
    for (let i = 0; i < data.phases.length; i++) {
      const phase = data.phases[i];

      if (!phase.phase) {
        errors.push(`Phase ${i}: missing phase identifier`);
      }

      if (!['not_started', 'in_progress', 'completed'].includes(phase.status)) {
        errors.push(`Phase ${i}: invalid status ${phase.status}`);
      }

      if (!Array.isArray(phase.tasks)) {
        errors.push(`Phase ${i}: tasks must be an array`);
      }

      if (phase.completion_percentage < 0 || phase.completion_percentage > 100) {
        errors.push(`Phase ${i}: completion_percentage must be between 0 and 100`);
      }
    }
  }

  if (!data.summary) {
    errors.push('Missing summary section');
  } else {
    if (data.summary.total_phases !== data.phases?.length) {
      warnings.push('summary.total_phases does not match phases array length');
    }
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings,
  };
}

/**
 * Validate checkpoints data
 */
export function validateCheckpointsData(data: CheckpointsData): ValidationResult {
  const errors: string[] = [];
  const warnings: string[] = [];

  if (!data.schema_version) {
    errors.push('Missing schema_version');
  }

  if (!data.project) {
    errors.push('Missing project section');
  }

  if (!Array.isArray(data.checkpoints)) {
    errors.push('checkpoints must be an array');
  } else {
    for (let i = 0; i < data.checkpoints.length; i++) {
      const checkpoint = data.checkpoints[i];

      if (!checkpoint.tag) {
        errors.push(`Checkpoint ${i}: missing tag`);
      }

      if (!checkpoint.commit) {
        errors.push(`Checkpoint ${i}: missing commit`);
      }

      if (!checkpoint.timestamp) {
        errors.push(`Checkpoint ${i}: missing timestamp`);
      } else if (isNaN(Date.parse(checkpoint.timestamp))) {
        errors.push(`Checkpoint ${i}: invalid timestamp format`);
      }

      if (!['task', 'phase', 'manual'].includes(checkpoint.type)) {
        errors.push(`Checkpoint ${i}: invalid type ${checkpoint.type}`);
      }

      if (!checkpoint.phase) {
        errors.push(`Checkpoint ${i}: missing phase`);
      }
    }

    // Check chronological order
    for (let i = 1; i < data.checkpoints.length; i++) {
      const prev = new Date(data.checkpoints[i - 1].timestamp);
      const curr = new Date(data.checkpoints[i].timestamp);

      if (curr < prev) {
        warnings.push(`Checkpoints ${i - 1} and ${i} are not in chronological order`);
      }
    }
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings,
  };
}

/**
 * Validate state consistency across files
 */
export function validateStateConsistency(
  sessionState: SessionState,
  progressData?: ProgressData,
  checkpointsData?: CheckpointsData
): ValidationResult {
  const errors: string[] = [];
  const warnings: string[] = [];

  // Validate session state first
  const sessionValidation = validateSessionState(sessionState);
  errors.push(...sessionValidation.errors);
  warnings.push(...sessionValidation.warnings);

  if (progressData) {
    // Check if current phase exists in progress data
    const currentPhase = sessionState.current.phase;
    const phaseExists = progressData.phases.some((p) => p.phase === currentPhase);

    if (!phaseExists) {
      errors.push(`Current phase ${currentPhase} not found in progress data`);
    }

    // Validate progress data
    const progressValidation = validateProgressData(progressData);
    errors.push(...progressValidation.errors);
    warnings.push(...progressValidation.warnings);
  }

  if (checkpointsData) {
    // Check if last checkpoint matches
    const sessionCheckpoint = sessionState.checkpoint.tag;
    const lastCheckpoint = checkpointsData.checkpoints[checkpointsData.checkpoints.length - 1];

    if (sessionCheckpoint && lastCheckpoint && sessionCheckpoint !== lastCheckpoint.tag) {
      warnings.push('Session state checkpoint does not match last checkpoint in history');
    }

    // Validate checkpoints data
    const checkpointsValidation = validateCheckpointsData(checkpointsData);
    errors.push(...checkpointsValidation.errors);
    warnings.push(...checkpointsValidation.warnings);
  }

  return {
    valid: errors.length === 0,
    errors,
    warnings,
  };
}

/**
 * Check if state is safe to modify
 */
export function isStateSafe(state: SessionState): boolean {
  const validation = validateSessionState(state);
  return validation.valid && state.git_state.working_directory_clean;
}

/**
 * Get validation summary
 */
export function getValidationSummary(result: ValidationResult): string {
  const lines: string[] = [];

  if (result.valid) {
    lines.push('✓ Validation passed');
  } else {
    lines.push('✗ Validation failed');
  }

  if (result.errors.length > 0) {
    lines.push('');
    lines.push('Errors:');
    for (const error of result.errors) {
      lines.push(`  - ${error}`);
    }
  }

  if (result.warnings.length > 0) {
    lines.push('');
    lines.push('Warnings:');
    for (const warning of result.warnings) {
      lines.push(`  - ${warning}`);
    }
  }

  return lines.join('\n');
}
