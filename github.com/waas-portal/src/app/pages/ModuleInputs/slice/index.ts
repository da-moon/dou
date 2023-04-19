import { PayloadAction } from '@reduxjs/toolkit';
import { RegistryModule } from 'types/RegistryModule';
import { createSlice } from 'utils/@reduxjs/toolkit';
import { useInjectReducer, useInjectSaga } from 'utils/redux-injectors';
import { moduleInputsStateSaga } from './saga';
import { ModuleInputsState, ModuleRegistryErrorType } from './types';

export const initialState: ModuleInputsState = {
  registry_module: {
    id: '',
    name: '',
    namespace: '',
    provider: '',
    description: '',
    root: {
      inputs: [],
    },
  },
  inputs: [],
  loading: false,
  error: null,
};

const slice = createSlice({
  name: 'moduleInputs',
  initialState,
  reducers: {
    loadRegistryModule(state) {
      state.loading = true;
      state.error = null;
      state.registry_module = {
        id: '',
        name: '',
        namespace: '',
        provider: '',
        description: '',
        root: {
          inputs: [],
        },
      };
      state.inputs = [];
    },
    registryModuleLoaded(state, action: PayloadAction<RegistryModule>) {
      const registry_module = action.payload;
      state.registry_module = registry_module;
      state.loading = false;
    },
    registryInputsLoaded(state, action: PayloadAction<any[]>) {
      const inputs = action.payload;
      state.inputs = inputs;
      state.loading = false;
    },
    registryModuleError(state, action: PayloadAction<ModuleRegistryErrorType>) {
      state.error = action.payload;
      state.loading = false;
    },
  },
});

export const { actions: moduleInputsActions } = slice;

export const useModuleInputsSlice = () => {
  useInjectReducer({ key: slice.name, reducer: slice.reducer });
  useInjectSaga({ key: slice.name, saga: moduleInputsStateSaga });
  return { actions: slice.actions };
};
