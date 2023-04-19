import { createSelector } from '@reduxjs/toolkit';

import { RootState } from 'types';
import { initialState } from '.';

const selectDomain = (state: RootState) => state.moduleInputs || initialState;

export const selectInputs = createSelector(
  [selectDomain],
  ModuleInputsState => ModuleInputsState.inputs,
);

export const selectLoading = createSelector(
  [selectDomain],
  ModuleInputsState => ModuleInputsState.loading,
);

export const selectError = createSelector(
  [selectDomain],
  ModuleInputsState => ModuleInputsState.error,
);

export const selectModuleRegistry = createSelector(
  [selectDomain],
  ModuleInputsState => ModuleInputsState.registry_module,
);

export const selectModuleNamespace = createSelector(
  [selectDomain],
  ModuleInputsState => ModuleInputsState.registry_module.namespace,
);
