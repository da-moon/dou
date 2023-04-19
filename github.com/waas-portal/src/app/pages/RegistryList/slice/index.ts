import { PayloadAction } from '@reduxjs/toolkit';
import { RegistryModules } from 'types/RegistryModules';
import { createSlice } from 'utils/@reduxjs/toolkit';
import { useInjectReducer, useInjectSaga } from 'utils/redux-injectors';
import { moduleRegistryFormStateSaga } from './saga';
import { ModuleRegistryFormStateState, ModuleRegistryErrorType } from './types';

export const initialState: ModuleRegistryFormStateState = {
  registry_modules: { data: [] },
  filter: [],
  module_name: '',
  module_version: '',
  module_provider: '',
  module_spw_url: '',
  module_spw_provider: '',
  loading: false,
  error: null,
};

const slice = createSlice({
  name: 'moduleRegistryFormState',
  initialState,
  reducers: {
    changeFilter(state, action: PayloadAction<string[]>) {
      state.filter = action.payload;
    },
    changeModuleName(state, action: PayloadAction<string>) {
      state.module_name = action.payload;
    },
    changeModuleVersion(state, action: PayloadAction<string>) {
      state.module_version = action.payload;
    },
    changeModuleProvider(state, action: PayloadAction<string>) {
      state.module_provider = action.payload;
    },
    changeModuleSpwUrl(state, action: PayloadAction<string>) {
      state.module_spw_url = action.payload;
    },
    changeModuleSpwProvider(state, action: PayloadAction<string>) {
      state.module_spw_provider = action.payload;
    },
    loadRegistryModules(state) {
      state.loading = true;
      state.error = null;
      state.filter = [];
      state.module_name = '';
      state.module_version = '';
      state.module_provider = '';
      state.module_spw_provider = '';
      state.module_spw_url = '';
      state.registry_modules = { data: [] };
    },
    registryModulesLoaded(state, action: PayloadAction<RegistryModules>) {
      const registry_modules = action.payload;
      state.registry_modules = registry_modules;
      state.loading = false;
    },
    registryModulesError(
      state,
      action: PayloadAction<ModuleRegistryErrorType>,
    ) {
      state.error = action.payload;
      state.loading = false;
    },
  },
});

export const { actions: moduleRegistryFormStateActions } = slice;

export const useModuleRegistryFormStateSlice = () => {
  useInjectReducer({ key: slice.name, reducer: slice.reducer });
  useInjectSaga({ key: slice.name, saga: moduleRegistryFormStateSaga });
  return { actions: slice.actions };
};
