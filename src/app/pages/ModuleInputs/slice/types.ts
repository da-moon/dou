import { RegistryModule } from 'types/RegistryModule';

export interface ModuleInputsState {
  loading: boolean;
  error?: ModuleRegistryErrorType | null;
  registry_module: RegistryModule;
  inputs: any[];
}

export enum ModuleRegistryErrorType {
  RESPONSE_ERROR = 1,
  HAS_NO_REGISTRY_MODULE = 2,
}

export type ContainerState = ModuleInputsState;
