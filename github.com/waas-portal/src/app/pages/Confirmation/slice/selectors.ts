import { createSelector } from '@reduxjs/toolkit';

import { RootState } from 'types';
import { initialState } from '.';

const selectDomain = (state: RootState) =>
  state.confirmationState || initialState;

export const selectWorkspace = createSelector(
  [selectDomain],
  ConfirmationStateState => ConfirmationStateState.workspace,
);

export const selectDeploy = createSelector(
  [selectDomain],
  ConfirmationStateState => ConfirmationStateState.deploy,
);

export const selectError = createSelector(
  [selectDomain],
  ConfirmationStateState => ConfirmationStateState.error,
);
