export interface ConfirmationStateState {
  loading: boolean;
  error?: DeployErrorType | null;
  workspace: string;
  deploy: boolean;
}

export enum DeployErrorType {
  RESPONSE_ERROR = 1,
}

export type ContainerState = ConfirmationStateState;
