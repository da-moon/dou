import { PayloadAction } from '@reduxjs/toolkit';
import { createSlice } from 'utils/@reduxjs/toolkit';
import { useInjectReducer, useInjectSaga } from 'utils/redux-injectors';
import { confirmationStateSaga } from './saga';
import { ConfirmationStateState, DeployErrorType } from './types';

export const initialState: ConfirmationStateState = {
  workspace: '',
  loading: false,
  error: null,
  deploy: false,
};

const slice = createSlice({
  name: 'confirmationState',
  initialState,
  reducers: {
    loadRegistryModule(state) {
      state.workspace = '';
      state.error = null;
      state.deploy = false;
      state.loading = false;
    },
    createService() {},
    changeDeployStatus(state, action: PayloadAction<boolean>) {
      state.deploy = action.payload;
    },
    changeWorkspace(state, action: PayloadAction<string>) {
      state.workspace = action.payload;
    },
    DeployError(state, action: PayloadAction<DeployErrorType>) {
      state.error = action.payload;
      state.loading = false;
    },
  },
});

export const { actions: confirmationStateActions } = slice;

export const useConfirmationStateSlice = () => {
  useInjectReducer({ key: slice.name, reducer: slice.reducer });
  useInjectSaga({ key: slice.name, saga: confirmationStateSaga });
  return { actions: slice.actions };
};
