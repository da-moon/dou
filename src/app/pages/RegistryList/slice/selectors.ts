import { createSelector } from '@reduxjs/toolkit';

import { RootState } from 'types';
import { initialState } from '.';

const selectDomain = (state: RootState) =>
  state.moduleRegistryFormState || initialState;

export const selectLoading = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.loading,
);

export const selectFilter = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.filter,
);

export const selectModuleName = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.module_name,
);

export const selectModuleProvider = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.module_provider,
);

export const selectModuleVersion = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.module_version,
);

export const selectModuleSpwUrl = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.module_spw_url,
);

export const selectModuleSpwProvider = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState =>
    ModuleRegistryFormStateState.module_spw_provider,
);

export const selectError = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.error,
);

export const selectModulesRegistry = createSelector(
  [selectDomain],
  ModuleRegistryFormStateState => ModuleRegistryFormStateState.registry_modules,
);
